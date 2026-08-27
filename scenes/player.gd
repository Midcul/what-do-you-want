extends CharacterBody2D

@export var speed: float = 400.0
var curr_food

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var interact = %Area2D.get_overlapping_areas()[0]
		if interact.is_in_group("food") and not curr_food:
			interact.get_parent().grab_order()

func collect_item(food) -> void:
	%Held_Item.texture = load(InitDishes.get_image_path(food))
