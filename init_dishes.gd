extends Node2D

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

func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var string = file.get_as_text()
	file.close()
	
	string = JSON.parse_string(string)
	var data = dict2onehot(string)
	return data
