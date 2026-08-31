extends Node2D

@onready var food = preload("uid://cn8lyif51lwhd")
@onready var customer = preload("uid://dprg8ap1gytl4")
@onready var title_screen = preload("uid://nx7iuqmpopd2")

@onready var seats = %Seats
@onready var orders = [%Marker5, %Marker4, %Marker3, %Marker2, %Marker1]
@onready var areas = [%Area1, %Area2, %Area3, %Area4, %Area5]
@onready var customer_info = [%Customer1, %Customer2, %Customer3]
@onready var chef = %Chef
@onready var start = %Start.position
@onready var finish = %End.position

@onready var food_ready = preload("uid://c0sg2838lsja4")
@onready var cus_arrived = preload("uid://5qrcn7x6knju")
@onready var day_lose = preload("uid://dsijjfqm1d7di")
@onready var day_win = preload("uid://b45crauvwiocq")

var customers_total = [7, 11, 15]
var day_count
var satisfied_count = 0

func _ready() -> void:
	%Tablet.connect("order_up", process_order)
	%Tablet.connect("tablet_closed", allow_player_movement)
	%Tablet.connect("tablet_opened", disable_player_movement)
	%Player.connect("place_food", drop_food_onto_tray)
	%Player.connect("priority_first", show_priority_warning)
	%Player.connect("move_tablet", toggle_tablet)
	InitDishes.connect("sloth", create_tutorial_sloth)
	InitDishes.connect("pig", create_tutorial_pig)
	InitDishes.connect("tablet_time", progress_dialogue)
	InitDishes.connect("wrong_answer1", wrong_answer.bind(0))
	InitDishes.connect("wrong_answer2", wrong_answer.bind(1))
	InitDishes.connect("begin_game", acquire_new_customers)
	InitDishes.connect("pause_game", pause_game)
	InitDishes.tutorial_marker = 0
	if InitDishes.in_tutorial:
		play_tutorial()
	else:
		acquire_new_customers()
		
func pause_game() -> void:
	if not get_tree().paused:
		%PauseUI.show()
		get_tree().paused = true
	
func play_tutorial() -> void:
	%ExampleBalloon.start(load("uid://1pod8lqgru26"), "start")
	
func create_tutorial_sloth() -> void:
	get_random_seat("Sloth")
	
func create_tutorial_pig() -> void:
	get_random_seat("Pig")
	
func progress_dialogue() -> void:
	match InitDishes.tutorial_marker:
		3:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "sloth_interact")
		4:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "tablet_opened")
		5:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "tablet_filter")
		6:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "chicken")
		7:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "served1")
		8:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "pig_interact")
		9:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "search")
		10:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "search")
		11:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "search_done")
		13:
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "finish")

func wrong_answer(answer) -> void:
	match answer:
		0:
			pass
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "wrong_filter1")
		1:
			pass
			%ExampleBalloon.start(load("uid://1pod8lqgru26"), "wrong_filter2")

func start_level() -> void:
	allow_player_movement()
	enable_tablet()
	for marker in orders:
		if marker.get_children().size() > 1:
			var node = marker.get_child(1)
			node.queue_free()
	satisfied_count = 0
	day_count = customers_total[InitDishes.level]
	_on_timer_timeout()
	
func disable_tablet() -> void:
	%Player.can_tablet = false
	
func enable_tablet() -> void:
	%Player.can_tablet = true
	
func allow_player_movement() -> void:
	if not %Player.talking:
		%Player.move_disabled = false
	
func disable_player_movement() -> void:
	AudioManager.stop_steps()
	%Player.move_disabled = true
	
func _on_tablet_pressed() -> void:
	if InitDishes.in_tutorial:
		if InitDishes.tutorial_marker == 3 or InitDishes.tutorial_marker == 9:
			pass
		else:
			return
	toggle_tablet()

func toggle_tablet() -> void:
	AudioManager.switch_track()
	if %Tablet.is_visible:
		%Tablet.hide_tablet()
	else:
		%Tablet.show_tablet()

func process_order(order) -> void:
	toggle_tablet()
	var potential_spots = []
	var rand_time = randf_range(2.0, 3.0)
	var new_food = food.instantiate()
	var final_pos
	for marker in orders:
		if marker.get_children().size() == 1:
			potential_spots.append(marker)
	if potential_spots.size() == 0: return
	var rand_spot = potential_spots.pick_random()
	rand_spot.add_child(new_food)
	final_pos = Vector2(rand_spot.global_position.x - 104, -8)
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
	tray.get_parent().add_child(new_food)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)

func show_priority_warning() -> void:
	for seat in seats.get_children():
		if seat.get_children().size() > 0 and seat.get_child(0).cus_type == "Peacock":
			seat.get_child(0).show_priority_warning()

func get_random_seat(tutorial = "") -> void:
	var empty = []
	for seat in seats.get_children():
		if seat.get_children().size() == 0:
			empty.append(seat)
	if empty.size() == 0:
		day_count += 1
		return
	assign_customer(empty.pick_random(), tutorial)
	
func assign_customer(seat, tutorial = "") -> void:
	var new_cus = customer.instantiate()
	if seats.get_children().find(seat) % 2 == 1:
		new_cus.flip_cus()
	#AudioManager.play_sfx(cus_seated)
	seat.add_child(new_cus)
	new_cus.randomize_customer(tutorial)
	new_cus.connect("check_day_end", check_for_day_end)
	new_cus.connect("correct_item", add_to_score)
	new_cus.connect("free_the_player", allow_player_movement)
	
func add_to_score() -> void:
	satisfied_count += 1
	
func check_for_day_end() -> void:
	if InitDishes.in_tutorial: return
	if day_count > 0: return
	var count = 0
	for seat in seats.get_children():
		if seat.get_children().size() > 0:
			count += 1
	if count == 1:
		%Tablet_Button.disabled = true
		await get_tree().create_timer(3.0).timeout
		go_to_results()
	
func game_complete() -> void:
	%Ending.show()
	AudioManager.stop_music()
	AudioManager.stop_sfx()
	
func go_to_results() -> void:
	%Player.drop_item()
	disable_tablet()
	%Tablet_Button.disabled = false
	AudioManager.stop_music()
	disable_player_movement()
	AudioManager.stop_steps()
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
	if InitDishes.level < 3:
		acquire_new_customers()
	else:
		game_complete()

func _on_retry_pressed() -> void:
	AudioManager.randomize_music()
	%Results.hide()
	start_level()

func acquire_new_customers() -> void:
	%Day_Start.show()
	var new_customers
	if InitDishes.level == 0:
		new_customers = ["Sloth", "Pig", "Bear"]
	elif InitDishes.level == 1:
		new_customers = ["Rabbit", "Crocodile", "Peacock"]
	elif InitDishes.level == 2:
		new_customers = ["Elephant", "Panther", "Fox"]
	for i in range(customer_info.size()):
			customer_info[i].set_info(new_customers[i])

func _on_continue_pressed() -> void:
	%Day_Start.hide()
	start_level()
	
func _on_continue_mouse_entered() -> void:
	%Continue.self_modulate = Color(1, 1, 1)

func _on_continue_mouse_exited() -> void:
	%Continue.self_modulate = Color(1, 1, 1, 0.66)

func _on_texture_button_pressed() -> void:
	%Ending.hide()
	get_tree().change_scene_to_file("uid://nx7iuqmpopd2")

func _on_example_balloon_visibility_changed() -> void:
	if %ExampleBalloon.visible:
		disable_player_movement()
	else:
		if InitDishes.tutorial_marker in [0, 1, 2, 3, 6, 7, 9, 12]:
			allow_player_movement()
