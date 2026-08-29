extends Node2D

@onready var food = preload("uid://cn8lyif51lwhd")
@onready var customer = preload("uid://dprg8ap1gytl4")

@onready var seats = %Seats
@onready var orders = [%Marker5, %Marker4, %Marker3, %Marker2, %Marker1]
@onready var chef = %Chef
@onready var start = %Start.position
@onready var finish = %End.position

@onready var food_ready = preload("uid://c0sg2838lsja4")
@onready var cus_arrived = preload("uid://5qrcn7x6knju")
@onready var day_lose = preload("uid://dsijjfqm1d7di")
@onready var day_win = preload("uid://b45crauvwiocq")

var customers_total = [5, 7, 9]
var day_count
var satisfied_count = 0

func _ready() -> void:
	%Tablet.connect("order_up", process_order)
	%Player.connect("place_food", drop_food_onto_tray)
	%Player.connect("priority_first", show_priority_warning)
	%Player.connect("move_tablet", toggle_tablet)
	#play_tutorial()
	start_level()
	
func play_tutorial() -> void:
	pass
	
func start_level() -> void:
	for marker in orders:
		if marker.get_children().size() > 1:
			marker.get_child(0).get_parent().queue_free()
	satisfied_count = 0
	day_count = customers_total[InitDishes.level]
	_on_timer_timeout()
	
func _on_tablet_pressed() -> void:
	toggle_tablet()

func toggle_tablet() -> void:
	AudioManager.switch_track()
	if %Tablet.is_visible:
		%Tablet.hide_tablet()
		%Player.move_disabled = false
	else:
		%Tablet.show_tablet()
		%Player.move_disabled = true

func process_order(order) -> void:
	toggle_tablet()
	var rand_time = randf_range(2.0, 4.0)
	var new_food = food.instantiate()
	var final_pos
	for marker in orders:
		if marker.get_children().size() == 1:
			marker.add_child(new_food)
			final_pos = Vector2(marker.global_position.x - 104, -8)
			break
	show_chef(rand_time, final_pos)
	await get_tree().create_timer(rand_time).timeout
	AudioManager.play_sfx(food_ready)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)
	
func show_chef(time, final_pos) -> void:
	var tween = get_tree().create_tween()
	if abs(start.x - final_pos.x) > abs(finish.x - final_pos.x):
		chef.position = start
	else:
		chef.position = finish
	chef.modulate.a = 1.0
	chef.show()
	tween.tween_property(chef, "position", final_pos, time)
	tween.tween_property(chef, "modulate:a", 0.0, 0.5)
	await tween.finished
	
func add_food_to_player(order) -> void:
	%Player.collect_item(order)

func drop_food_onto_tray(order, tray) -> void:
	var new_food = food.instantiate()
	tray.add_child(new_food)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)

func show_priority_warning() -> void:
	for seat in seats.get_children():
		if seat.get_children().size() > 0 and seat.get_child(0).cus_type == "Peacock":
			seat.get_child(0).show_priority_warning()

func get_random_seat() -> void:
	var empty = []
	for seat in seats.get_children():
		if seat.get_children().size() == 0:
			empty.append(seat)
	if empty.size() == 0:
		day_count += 1
		return
	assign_customer(empty.pick_random())
	
func assign_customer(seat) -> void:
	var new_cus = customer.instantiate()
	if seats.get_children().find(seat) % 2 == 1:
		new_cus.flip_cus()
	#AudioManager.play_sfx(cus_seated)
	seat.add_child(new_cus)
	new_cus.connect("check_day_end", check_for_day_end)
	new_cus.connect("correct_item", add_to_score)
	
func add_to_score() -> void:
	satisfied_count += 1
	
func check_for_day_end() -> void:
	if day_count > 0: return
	var count = 0
	for seat in seats.get_children():
		if seat.get_children().size() > 0:
			count += 1
	if count == 1:
		go_to_results()
	
func go_to_results() -> void:
	AudioManager.stop_music()
	%Proceed.hide()
	%Retry.hide()
	%Results.show()
	%Score.text = "[b]" + str(satisfied_count) + " / " + str(customers_total[InitDishes.level]) + "[/b]"
	if satisfied_count > customers_total[InitDishes.level] / 2:
		AudioManager.play_sfx(day_win)
		%Outcome.text = "SUCCESS!"
		%Proceed.show()
	else:
		AudioManager.play_sfx(day_lose)
		%Outcome.text = "FAILED!"
		%Retry.show()
	
func _on_tablet_button_mouse_entered() -> void:
	%Tablet_Button.self_modulate = Color(1, 1, 1)

func _on_tablet_button_mouse_exited() -> void:
	%Tablet_Button.self_modulate = Color(1, 1, 1, 0.5)

func _on_timer_timeout() -> void:
	get_random_seat()
	day_count -= 1
	AudioManager.play_sfx(cus_arrived)
	if day_count > 0:
		%Timer.wait_time = randf_range(10, 15)
		%Timer.start()

func _on_proceed_pressed() -> void:
	AudioManager.randomize_music()
	%Results.hide()
	InitDishes.level += 1
	start_level()

func _on_retry_pressed() -> void:
	AudioManager.randomize_music()
	%Results.hide()
	start_level()
