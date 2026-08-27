extends Node2D

@onready var food = preload("uid://cn8lyif51lwhd")

func _ready() -> void:
	%Tablet.hide_tablet()
	%Tablet.connect("order_up", process_order)

func _on_tablet_pressed() -> void:
	%Tablet.show_tablet()

func process_order(order) -> void:
	var new_food = food.instantiate()
	%Orders.add_child(new_food)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)
	
func add_food_to_player(order) -> void:
	%Player.collect_item(order)
