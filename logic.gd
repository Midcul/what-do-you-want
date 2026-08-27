extends Node2D

@onready var menu = InitDishes.menu

func update_notes(state: Array[int], update: Array[int]) -> Array[int]:
	# State is a vector with all known order information in it
	# This function pushes an update (e.g., a whole dish, one tag) to state
	
	# 0 NO
	# 1 YES
	# 2 Possible trait
	for i in range(update.size()):
		# TEMPORARY -- ONLY ACCOMMODATING POSITIVE CLUES. ADD AN ARGUMENT TO CHANGE BEHAVIOR
		if update[i] != 0:
			state[i] = update[i]
	return state
	
func get_possible(state: Array[int], pool: Array = menu.keys()) -> Array:
	# Given a state, find all dishes in the pool that the state could describe
	# This should be used to check answers, or to guide the search engine
	
	var ret = []
	for dish in pool:
		var flag = false
		var dish_as_vec = dish2vec(dish)
		
		for i in range(state.size()):
			if state[i] == 2:
				continue
				
			if dish_as_vec[i] != state[i]:
				flag = true
		
		if not flag:
			ret.append(dish)
	
	return ret

func dish2vec(dish: String) -> Array[int]:
	var ret: Array[int] = []
	ret.resize(12)
	ret.fill(0)
	# white, green, red, yellow
	# handheld, medley, pasta, soup
	# cheesy, fishy, meaty, veggie
	const word2element = {'White': 0, 'Green': 1, 'Red': 2, 'Yellow': 3,
	'Handheld': 4, 'Medley': 5, 'Pasta': 6, 'Soup': 7,
	'Cheesy': 8, 'Fishy': 9, 'Meaty': 10, 'Veggie': 11}
	
	for i in ['Tag1', 'Tag2', 'Tag3']:
		var tag = menu[dish][i]
		var num = word2element[tag]
		ret[num] = 2
	return ret

func select_from_menu(menu: Dictionary) -> Array:
	var keys = menu.keys()
	keys.shuffle()
	return keys.slice(0, 3)

func create_quadruplet(character: String):
	var state: Array[int] = []
	state.resize(12)
	state.fill(0)
	
	var hints = select_from_menu(menu)
	for hint in hints:
		state = update_notes(state, dish2vec(hint))
	
	hints.append(get_possible(state))
	return hints
	
func _ready():
	print(create_quadruplet(""))
	
