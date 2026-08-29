extends CharacterBody2D
signal correct_item
signal wrong_item
signal check_day_end
#signal start_convo(customer)

@onready var patience = %Timer
@onready var patience_bar = %ProgressBar
@onready var convo = %Customer_UI
@onready var end_pos = %Priority.position
@onready var priority_warning = %Priority

@onready var pay_attention = preload("uid://dlssk6mbalbm8")

const GREEN = Color("00ff00")
const YELLOW = Color("ffff00")
const RED = Color("ff0000")
var base_time = 60.0
var is_talking = false
var cus_type 
var cus_name
var clues
var clue_type
var desired_dish

func _ready() -> void:
	convo.connect("reduce_patience", reduce_customer_patience)
	randomize_customer()

func _physics_process(delta: float) -> void:
	patience_bar.value = 100.0 * patience.time_left / base_time
	convo.update_patience(patience_bar.value)
	if patience_bar.value < 33.3:
		patience_bar.modulate = RED
	elif patience_bar.value < 66.7:
		patience_bar.modulate = YELLOW

func randomize_customer(tutorial = false) -> void:
	var data
	if tutorial:
		cus_type = tutorial
		match tutorial:
			"Sloth":
				data = ["Red", "Handheld", "Meaty", "Fried Chicken"]
			"Pig":
				data = ["Pepperoni Pizza", "Escargot", "Shivit Oshi", "St. Patty Melt"]
	else:
		cus_type = InitDishes.customer_pool[InitDishes.level].pick_random()
		data = Logic.set_up_customer(cus_type)
		if cus_type == "Peacock":
			InitDishes.priority_count += 1
	var img_path = InitDishes.customers[cus_type]["Image"]
	%Customer_Texture.texture = load(img_path)
	%Timer.wait_time = InitDishes.customers[cus_type]["Patience"]
	cus_name = InitDishes.customers[cus_type]["Names"].pick_random()
	convo.update_cus_image(img_path)
	convo.update_cus_name(cus_name)
	convo.set_timers(cus_type)
	clues = data.slice(0, 3)
	desired_dish = data[3]
	clue_type = data[4]
	convo.create_dialogue(cus_type, clues, clue_type)

func reduce_customer_patience(time_lost) -> void:
	var new_time = max(0.1, patience.time_left - time_lost)
	patience.stop()
	patience.wait_time = new_time
	patience.start()

func start_conversation() -> void:
	convo.show_ui()
	is_talking = true
	#emit_signal("start_convo", self)
	
func stop_conversation() -> void:
	convo.hide_ui()
	is_talking = false

func flip_cus() -> void:
	%Customer_Texture.flip_h = true

func show_priority_warning() -> void:
	var tween = get_tree().create_tween()
	AudioManager.play_sfx(pay_attention)
	priority_warning.position = %Start_Pos.position
	priority_warning.modulate.a = 1.0
	priority_warning.show()
	tween.tween_property(priority_warning, "position", %End_Pos.position, 0.25)
	tween.tween_property(priority_warning, "modulate:a", 0.0, 0.25)
	await tween.finished
	
### What to do when food is served? Do we penalize player if they get it wrong
func serve_food(food = "") -> void:
	#AudioManager.play_sfx(leave_cus)
	if cus_type == "Peacock":
		InitDishes.priority_count -= 1
	if food == desired_dish:
		#AudioManager.play_sfx(load(InitDishes.customers[cus_type]["Correct"].pick_random()))
		emit_signal("correct_item")
	else:
		#AudioManager.play_sfx(load(InitDishes.customers[cus_type]["Wrong"].pick_random()))
		emit_signal("wrong_item")
	emit_signal("check_day_end")
	queue_free()

func _on_timer_timeout() -> void:
	serve_food()
