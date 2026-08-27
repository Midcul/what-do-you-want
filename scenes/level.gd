extends Node2D

@onready var food = preload("uid://cn8lyif51lwhd")
@onready var customer = preload("uid://dprg8ap1gytl4")

@onready var seats = %Seats
@onready var orders = %Orders

func _ready() -> void:
	%Tablet.hide_tablet()
	%Tablet.connect("order_up", process_order)
	get_random_seat()
	get_random_seat()
	get_random_seat()

func _on_tablet_pressed() -> void:
	%Tablet.show_tablet()

func process_order(order) -> void:
	var new_food = food.instantiate()
	orders.add_child(new_food)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)
	
func add_food_to_player(order) -> void:
	%Player.collect_item(order)

func get_random_seat() -> void:
	var empty = []
	for seat in seats.get_children():
		if seat.get_children().size() == 0:
			empty.append(seat)
	assign_customer(empty.pick_random())
	
func assign_customer(seat) -> void:
	var new_cus = customer.instantiate()
	seat.add_child(new_cus)
