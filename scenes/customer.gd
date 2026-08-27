extends CharacterBody2D
signal start_convo(customer)

@onready var patience = %Timer
@onready var patience_bar = %ProgressBar
@onready var convo = %Customer_UI
const GREEN = Color("00ff00")
const YELLOW = Color("ffff00")
const RED = Color("ff0000")
var base_time = 60.0
var is_talking = false

func _ready() -> void:
	convo.connect("reduce_patience", reduce_customer_patience)

func _physics_process(delta: float) -> void:
	patience_bar.value = 100.0 * patience.time_left / base_time
	convo.update_patience(patience_bar.value)
	if patience_bar.value < 33.3:
		patience_bar.modulate = RED
	elif patience_bar.value < 66.7:
		patience_bar.modulate = YELLOW

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

### What to do when food is served? Do we penalize player if they get it wrong
func serve_food(food) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
