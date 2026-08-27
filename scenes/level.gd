extends Node2D

@onready var food = preload("uid://cn8lyif51lwhd")
@onready var customer = preload("uid://dprg8ap1gytl4")

@onready var seats = %Seats
@onready var orders = [%Marker5, %Marker4, %Marker3, %Marker2, %Marker1]


func _ready() -> void:
	%Tablet.hide_tablet()
	%Tablet.connect("order_up", process_order)
	%Player.connect("place_food", drop_food_onto_tray)
	get_random_seat()
	get_random_seat()
	get_random_seat()

func _on_tablet_pressed() -> void:
	%Tablet.show_tablet()

func process_order(order) -> void:
	var new_food = food.instantiate()
	for marker in orders:
		if marker.get_children().size() == 1:
			marker.add_child(new_food)
			break
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)
	
func add_food_to_player(order) -> void:
	%Player.collect_item(order)

func drop_food_onto_tray(order, tray) -> void:
	var new_food = food.instantiate()
	tray.add_child(new_food)
	new_food.set_order(order)
	new_food.connect("order_grabbed", add_food_to_player)

func get_random_seat() -> void:
	var empty = []
	for seat in seats.get_children():
		if seat.get_children().size() == 0:
			empty.append(seat)
	assign_customer(empty.pick_random())
	
func assign_customer(seat) -> void:
	var new_cus = customer.instantiate()
	seat.add_child(new_cus)
