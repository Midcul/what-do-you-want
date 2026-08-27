extends Node2D
signal order_grabbed(order)

var order_name

func set_order(food_name: String) -> void:
	order_name = food_name
	%Texture.texture = load(InitDishes.menu[food_name]["Image"])
	
func grab_order() -> void:
	emit_signal("order_grabbed", order_name)
	queue_free()
