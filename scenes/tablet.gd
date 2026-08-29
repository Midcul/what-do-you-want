extends Node2D
signal order_up(order)
signal move_tablet

@onready var tablet_up = preload("uid://botodbnjitpwj")
@onready var tablet_down = preload("uid://cn356fxldplqo")

var prev_button
var curr_order
var applied_filters = []
var is_visible = false

func _ready() -> void:
	clear_menu()
	load_menu()
	load_filters()
	get_menu_data(%Menu_Options.get_child(0), "Quesadilla")
	
func load_filters() -> void:
	for tag in Logic.color + Logic.composition + Logic.taste:
		var button = TextureButton.new()
		var label = RichTextLabel.new()
		label.text = tag
		label.size = Vector2(200, 50)
		button.texture_normal = load("uid://b4l8qivfx2o5l")
		button.stretch_mode = TextureRect.STRETCH_SCALE
		button.custom_minimum_size = Vector2(200, 50)
		button.toggle_mode = true
		button.self_modulate = Color(1, 1, 1, 0.5)
		%Filters.add_child(button)
		button.add_child(label)
		label.set_anchors_preset(Control.PRESET_FULL_RECT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.connect("toggled", add_filter.bind(button, tag))
	
func hide_tablet() -> void:
	#emit_signal("tablet_closed")
	AudioManager.play_sfx(tablet_down)
	%Canvas.hide()
	%Filter_Layer.hide()
	is_visible = false
	
func show_tablet() -> void:
	AudioManager.play_sfx(tablet_up)
	%Canvas.show()
	is_visible = true
	
func load_menu(menu = InitDishes.menu.keys()) -> void:
	menu.sort()
	for item in menu:
		var button = TextureButton.new()
		var rich_text = RichTextLabel.new()
		button.texture_normal = load("uid://b4l8qivfx2o5l")
		button.custom_minimum_size = Vector2(400, 70)
		button.stretch_mode = TextureButton.STRETCH_SCALE
		%Menu_Options.add_child(button)
		button.add_child(rich_text)
		rich_text.text = InitDishes.menu[item]["Dish Name"]
		rich_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rich_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		rich_text.size = Vector2(400, 70)
		rich_text.set_anchors_preset(Control.PRESET_FULL_RECT)
		rich_text.add_theme_font_size_override("normal_font_size", 28)
		rich_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.connect("pressed", get_menu_data.bind(button, item))
	
func clear_menu() -> void:
	for item in %Menu_Options.get_children():
		item.queue_free()

func filter_menu() -> void:
	clear_menu()
	load_menu(Logic.generate_sublist(applied_filters))

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
	AudioManager.switch_track()
	hide_tablet()
	
func _on_filter_pressed() -> void:
	%Filter_Layer.visible = true
	
func add_filter(toggled, button, tag):
	if toggled:
		button.self_modulate = Color(1, 1, 1)
		applied_filters.append(tag)
	else:
		button.self_modulate = Color(1, 1, 1, 0.5)
		applied_filters.erase(tag)

func _on_filter_mouse_entered() -> void:
	%Filter_Button.self_modulate = Color(1, 1, 1)
	%Filter.self_modulate = Color(1, 1, 1)

func _on_filter_mouse_exited() -> void:
	%Filter_Button.self_modulate = Color(1, 1, 1, 0.5)
	%Filter.self_modulate = Color(1, 1, 1, 0.5)
	
func _on_filter_button_pressed() -> void:
	filter_menu()
	%Filter_Layer.visible = false
