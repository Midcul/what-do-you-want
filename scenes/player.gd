extends CharacterBody2D
signal priority_first
signal place_food(food, tray)
signal move_tablet

@export var speed: float = 400.0
var can_tablet = true
var curr_food
var move_disabled = false
var talking = false
enum state {IDLE, WALK}
var curr_state = state.IDLE

func _physics_process(delta: float) -> void:
	if not move_disabled:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_direction * speed
		if velocity and curr_state != state.WALK:
			curr_state = state.WALK
			AudioManager.play_steps()
		elif not velocity and curr_state != state.IDLE:
			curr_state = state.IDLE
			AudioManager.stop_steps()
		move_and_slide()

func _input(event: InputEvent) -> void:
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
				#if InitDishes.priority_count > 0 and body.get_parent().cus_type != "Peacock": 
					#emit_signal("priority_first")
					#return 
				body.get_parent().serve_food(curr_food)
				drop_item()
				return
			elif body.is_in_group("customer") and not curr_food:
				if body.get_parent().is_talking:
					if body.get_parent().is_tutorial and not body.get_parent().talk_done: 
						return
					else:
						body.get_parent().stop_conversation()
						talking = false
						move_disabled = false
						if InitDishes.tutorial_marker == 2 or InitDishes.tutorial_marker == 8:
							if InitDishes.tutorial_marker == 2:
								InitDishes.tutorial_marker += 1
							InitDishes.progress_tutorial()
				elif InitDishes.priority_count > 0 and body.get_parent().cus_type != "Peacock": 
					emit_signal("priority_first")
					return 
				else:
					if body.get_parent().is_tutorial:
						if not body.get_parent().talk_trigger:
							move_disabled = true
							body.get_parent().talk_trigger = true
							InitDishes.tutorial_marker += 1
						else:
							return
					body.get_parent().start_conversation()
					talking = true
					AudioManager.stop_steps()
					move_disabled = true
				return
	elif Input.is_action_just_pressed("tablet"):
		if not can_tablet: return
		if InitDishes.in_tutorial:
			if InitDishes.tutorial_marker == 3 or InitDishes.tutorial_marker == 9:
				pass
			else:
				return
		#var interact = %Area2D.get_overlapping_areas()
		#for body in interact:
			#if body.is_in_group("customer") and not curr_food:
				#if body.get_parent().is_talking:
					#return
		emit_signal("move_tablet")

func collect_item(food) -> void:
	%Held_Item.texture = load(InitDishes.get_image_path(food))
	
func drop_item() -> void:
	await get_tree().process_frame
	if not InitDishes.in_tutorial: 
		move_disabled = false
	%Held_Item.texture = null
	curr_food = null
