extends Node2D
signal order_up(order)

var prev_button
var curr_order

func _ready() -> void:
	clear_menu()
	load_menu()
	
func hide_tablet() -> void:
	%Canvas.hide()
	
func show_tablet() -> void:
	%Canvas.show()
	
func load_menu() -> void:
	for item in InitDishes.menu.keys():
		var button = TextureButton.new()
		var rich_text = RichTextLabel.new()
		button.texture_normal = load("uid://b4l8qivfx2o5l")
		button.custom_minimum_size = Vector2(350, 70)
		button.stretch_mode = TextureButton.STRETCH_SCALE
		%Menu_Options.add_child(button)
		button.add_child(rich_text)
		rich_text.text = InitDishes.menu[item]["Dish Name"]
		rich_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rich_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		rich_text.size = Vector2(350, 70)
		rich_text.set_anchors_preset(Control.PRESET_FULL_RECT)
		rich_text.add_theme_font_size_override("normal_font_size", 32)
		rich_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.connect("pressed", get_menu_data.bind(button, item))
	
func clear_menu() -> void:
	for item in %Menu_Options.get_children():
		item.queue_free()

func get_menu_data(button: TextureButton, food_name: String) -> void:
	if prev_button:
		prev_button.self_modulate = Color(1, 1, 1)
	button.self_modulate = Color(1, 1, 0, 0.5)
	prev_button = button
	curr_order = food_name
	%Food_Name.text = food_name
	%Food_Img.texture = load(InitDishes.menu[food_name]["Image"])
	%Tag1.text = InitDishes.menu[food_name]["Tag1"]
	%Tag2.text = InitDishes.menu[food_name]["Tag2"]
	%Tag3.text = InitDishes.menu[food_name]["Tag3"]

func _on_tablet_button_pressed() -> void:
	hide_tablet()

func _on_order_pressed() -> void:
	emit_signal("order_up", curr_order)
	hide_tablet()

func _on_exit_pressed() -> void:
	hide_tablet()
