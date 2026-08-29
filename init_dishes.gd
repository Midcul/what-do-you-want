extends Node2D

var menu
var customers
var priority_count = 0
var level = 0
var customer_pool = [["Sloth", "Pig", "Bear"], ["Sloth", "Pig", "Bear", "Rabbit", "Crocodile", "Peacock"], ["Sloth", "Pig", "Bear", "Rabbit", "Crocodile", "Peacock", "Elephant", "Fox", "Panther"]]

func _ready() -> void:
	menu = load_menu("res://dishes.json")
	customers = load_customers("res://animals.json")

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
