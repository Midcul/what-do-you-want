extends Node2D
signal sloth
signal pig
signal tablet_time
signal wrong_answer1
signal wrong_answer2
signal begin_game
signal pause_game

var menu
var customers
var priority_count = 0
var level = 0
var customer_pool = [["Sloth", "Pig", "Bear"], ["Sloth", "Pig", "Bear", "Rabbit", "Crocodile", "Peacock"], ["Sloth", "Pig", "Bear", "Rabbit", "Crocodile", "Peacock", "Elephant", "Fox", "Panther"]]
var tablet_opened = false
var cus_dialogue_opened = false
var in_tutorial = true
var tutorial_marker = 0

func _ready() -> void:
	menu = load_menu("res://dishes.json")
	customers = load_customers("res://animals.json")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause_game")

func create_sloth() -> void:
	emit_signal("sloth")

func create_pig() -> void:
	emit_signal("pig")
	
func progress_tutorial() -> void:
	emit_signal("tablet_time")
	
func send_wrong_signal1() -> void:
	emit_signal("wrong_answer1")
	
func send_wrong_signal2() -> void:
	emit_signal("wrong_answer2")

func start_game() -> void:
	in_tutorial = false
	emit_signal("begin_game")
	
func dict2onehot(input: Array) -> Dictionary:
	var cols = ["Herbivore", "Carnivore", "Omnivore",
				"Salty", "Sweet", "Sour", "Bitter", "Spicy", "Meaty", 
				"Crispy", "Creamy"]
	
	var ret = {}
	
	for dish in input:
		var dish_name = dish['Dish Name']
		var vec = []
		
		for col in cols:
			vec.append(int(dish.get(col, '0')))
		
		ret[dish_name] = vec
	
	return ret

### Bypassed old load_json to make nested dictionary
func load_menu(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var string = file.get_as_text()
	file.close()
	
	var ret = {}
	string = JSON.parse_string(string)
	for dish in string:
		var dish_name = dish["Dish Name"]
		ret[dish_name] = dish
	return ret

func load_customers(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var string = file.get_as_text()
	file.close()
	
	var ret = {}
	string = JSON.parse_string(string)
	for cus in string:
		var cus_name = cus["Animal Name"]
		ret[cus_name] = cus
	return ret

func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var string = file.get_as_text()
	file.close()
	
	string = JSON.parse_string(string)
	var data = dict2onehot(string)
	return data

func get_image_path(food_name: String) -> String:
	return menu[food_name]["Image"]
	
func get_tags(food_name: String) -> String:
	return menu[food_name]["Tag1"] + " | " + menu[food_name]["Tag2"] + " | " + menu[food_name]["Tag3"]
