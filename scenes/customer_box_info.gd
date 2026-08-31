extends TextureRect

func set_info(cus_type) -> void:
	%Name.text = cus_type
	%Image.texture = load(InitDishes.customers[cus_type]["Image"])
	%Description.text = InitDishes.customers[cus_type]["Info"]
