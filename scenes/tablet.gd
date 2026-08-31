extends Node2D
signal order_up(order)
signal tablet_closed
signal tablet_opened

@onready var tablet_up = preload("uid://botodbnjitpwj")
@onready var tablet_down = preload("uid://cn356fxldplqo")
@onready var filter = %Food_Filter
@onready var regex = RegEx.new()
@onready var checks = %Checks
@onready var box1 = %Box1
@onready var box2 = %Box2
@onready var box3 = %Box3

var prev_button
var curr_order
var filter_txt = ""
var applied_filters = []
var is_visible = false

var pizza_checked = false
var escargot_checked = false
var shivit_checked = false

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
	if InitDishes.in_tutorial and (InitDishes.tutorial_marker == 4 or InitDishes.tutorial_marker == 10):
		return
	emit_signal("tablet_closed")
	AudioManager.play_sfx(tablet_down)
	%Canvas.hide()
	%Filter_Layer.hide()
	is_visible = false
	
func show_tablet() -> void:
	emit_signal("tablet_opened")
	AudioManager.play_sfx(tablet_up)
	%Canvas.show()
	is_visible = true
	if InitDishes.in_tutorial and (InitDishes.tutorial_marker == 3 or InitDishes.tutorial_marker == 9):
		InitDishes.tutorial_marker += 1
		InitDishes.progress_tutorial()
		if InitDishes.tutorial_marker == 10:
			checks.show()
	
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
	load_menu(Logic.generate_sublist(applied_filters, filter_txt))

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
	if InitDishes.tutorial_marker == 10:
		if curr_order == "Pepperoni Pizza":
			pizza_checked = true
			finish_check(box1)
		elif curr_order == "Escargot":
			escargot_checked = true
			finish_check(box2)
		elif curr_order == "Shivit Oshi":
			shivit_checked = true
			finish_check(box3)
		verify_all_checks()
	
func finish_check(box) -> void:
	box.modulate = Color(0, 1, 0)
	box.get_child(0).texture = load("uid://bph48lsh2pr2j")
	
func verify_all_checks() -> void:
	if pizza_checked and escargot_checked and shivit_checked:
		InitDishes.tutorial_marker += 1
		InitDishes.progress_tutorial()
		checks.hide()

func _on_tablet_button_pressed() -> void:
	if InitDishes.in_tutorial:
		return
	hide_tablet()
	remove_filters()
	filter_menu()

func _on_order_pressed() -> void:
	if InitDishes.in_tutorial:
		if InitDishes.tutorial_marker == 6 and curr_order == "Fried Chicken":
			pass
		elif InitDishes.tutorial_marker == 12 and curr_order == "St. Patty Melt":
			pass
		else:
			return
	emit_signal("order_up", curr_order)
	hide_tablet()
	remove_filters()
	filter_menu()

func _on_exit_pressed() -> void:
	if InitDishes.in_tutorial:
		return
	AudioManager.switch_track()
	hide_tablet()
	remove_filters()
	filter_menu()
	
func _on_filter_pressed() -> void:
	if InitDishes.in_tutorial:
		if InitDishes.tutorial_marker == 4:
			InitDishes.tutorial_marker += 1
			InitDishes.progress_tutorial()
		elif InitDishes.tutorial_marker == 11:
			InitDishes.tutorial_marker += 1
		else:
			return
	%Filter_Layer.visible = true
	
func add_filter(toggled, button, tag):
	if toggled:
		button.self_modulate = Color(1, 1, 1)
		applied_filters.append(tag)
	else:
		button.self_modulate = Color(1, 1, 1, 0.5)
		applied_filters.erase(tag)
		
func remove_filters():
	for button in %Filters.get_children():
		button.self_modulate = Color(1, 1, 1, 0.5)
		button.button_pressed = false
	applied_filters.clear()
	filter.clear()
	_on_food_filter_text_changed("")
	filter_menu()

func _on_filter_mouse_entered() -> void:
	%Filter_Button.self_modulate = Color(1, 1, 1)
	%Filter.self_modulate = Color(1, 1, 1)

func _on_filter_mouse_exited() -> void:
	%Filter_Button.self_modulate = Color(1, 1, 1, 0.5)
	%Filter.self_modulate = Color(1, 1, 1, 0.5)
	
func _on_filter_button_pressed() -> void:
	if InitDishes.in_tutorial:
		applied_filters.sort()
		if InitDishes.tutorial_marker == 5:
			if applied_filters == ["Handheld", "Meaty", "Red"]:
				InitDishes.tutorial_marker += 1
				InitDishes.progress_tutorial()
			else:
				InitDishes.send_wrong_signal1()
				return
		elif InitDishes.tutorial_marker == 10:
			if applied_filters == ["Green", "Handheld", "Meaty"]:
				InitDishes.tutorial_marker += 1
				InitDishes.progress_tutorial()
			else:
				InitDishes.send_wrong_signal2()
				return
	filter_menu()
	%Filter_Layer.visible = false

func _on_food_filter_text_changed(new_text: String) -> void:
	regex.compile("[A-Za-z\\s+]")
	var cursor_pos = filter.caret_column
	var matches = regex.search_all(new_text)
	var valid_text = ""
	for str_match in matches:
		valid_text += str_match.get_string()
		
	if valid_text != new_text:
		filter.text = filter_txt
		filter.caret_column = cursor_pos - filter.length() + filter.length() 
	else:
		filter_txt = new_text
	filter_menu()
