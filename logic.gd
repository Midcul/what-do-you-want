extends Node2D

@onready var menu = InitDishes.menu
const color = ['White', 'Green', 'Red', 'Yellow']
const composition = ['Handheld', 'Medley', 'Pasta', 'Soup']
const taste = ['Cheesy', 'Fishy', 'Meaty', 'Veggie']

func generate_positive_quadruplet_from_dishes() -> Array[String]:
	var tags: Array[String] = []
	var decoys: Array[String] = []
	var tri: Array[String]
	var ans: String
	
	for i in [color, composition, taste]:
		var temp = i.duplicate()
		temp.shuffle()
		var selections = temp.slice(0, 2)
		tags.append(selections[0])
		decoys.append(selections[1])
	
	for value in menu.values():
		var traits = [value['Tag1'], value['Tag2'], value['Tag3']]
		if traits == tags:
			ans = value['Dish Name']
		
		if traits in [[tags[0], tags[1], decoys[2]], [tags[0], decoys[1], tags[2]], [decoys[0], tags[1], tags[2]]]:
			tri.append(value['Dish Name'])
	
	tri.shuffle()
	tri.append(ans)
	return tri

func generate_negative_quadruplet_from_dishes() -> Array[String]:
	var tags: Array[String] = []
	var decoys: Array[Array] = [[], [], []]
	var tri: Array[String]
	var ans: String
	
	for i in [color, composition, taste]:
		var temp = i.duplicate()
		var selection = i.pick_random()
		tags.append(selection)
		temp.erase(selection)
		temp.shuffle()
		for j in range(temp.size()):
			decoys[j].append(temp[j])
		
	for value in menu.values():
		var traits = [value['Tag1'], value['Tag2'], value['Tag3']]
		if traits == tags:
			ans = value['Dish Name']
		
		if traits in decoys:
			tri.append(value['Dish Name'])
	
	tri.shuffle()
	tri.append(ans)
	return tri

func generate_positive_quadruplet_from_tags() -> Array[String]:
	var tags: Array[String] = []
	var ans: String
	
	for i in [color, composition, taste]:
		tags.append(i.pick_random())
		
	for value in menu.values():
		var traits = [value['Tag1'], value['Tag2'], value['Tag3']]
		if traits == tags:
			ans = value['Dish Name']
			break
		
	tags.shuffle()
	tags.append(ans)
	return tags

func _ready():
	print(generate_positive_quadruplet_from_dishes())
	print(generate_negative_quadruplet_from_dishes())
	print(generate_positive_quadruplet_from_tags())
	
