extends CharacterBody2D
signal place_food(food, tray)
signal pause_request()

@export var speed: float = 400.0
var curr_food

func _pausecheck():
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("pause_request")
		get_tree().paused = true

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var interact = %Area2D.get_overlapping_areas()
		for body in interact:
			if body.is_in_group("food") and not curr_food:
				curr_food = body.get_parent().order_name
				body.get_parent().grab_order()
				return
			elif body.is_in_group("tray") and interact.size() < 2 and curr_food:
				emit_signal("place_food", curr_food, body)
				drop_item()
				return
			elif body.is_in_group("customer") and curr_food:
				body.get_parent().serve_food(curr_food)
				drop_item()
				return
			elif body.is_in_group("customer") and not curr_food:
				if body.get_parent().is_talking:
					body.get_parent().stop_conversation()
				else:
					body.get_parent().start_conversation()
				return

func collect_item(food) -> void:
	%Held_Item.texture = load(InitDishes.get_image_path(food))
	
func drop_item() -> void:
	%Held_Item.texture = null
	curr_food = null
	
#Runtime Functionality
func _process(delta):
	_pausecheck()
