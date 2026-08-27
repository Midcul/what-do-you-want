extends Node2D

@onready var menu = InitDishes.menu

func update_notes(state: Array[Array], update: Array[int]) -> Array[Array]:
	# State is a vector with all known order information in it
	# This function pushes an update (e.g., a whole dish, one tag) to state
	
	for i in range(update.size()):
		# TEMPORARY -- ONLY ACCOMMODATING POSITIVE CLUES. ADD AN ARGUMENT TO CHANGE BEHAVIOR
		state[i].append(update[i])
	return state
	
func get_possible(state: Array[Array], pool: Array = menu.keys()) -> Array:
	# Given a state, find all dishes in the pool that the state could describe
	# This should be used to check answers, or to guide the search engine
	
	var ret = []
	for dish in pool:
		var check = []
		var dish_as_vec = dish2vec(dish, 1)
		
		for i in range(dish_as_vec.size()):
			if dish_as_vec[i] == 1:
				check.append_array(state[i])
		
		if 1 in check and 2 in check and 3 in check:
			ret.append(dish)
	
	return ret

func dish2vec(dish: String, dish_seq: int) -> Array[int]:
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
		ret[num] = dish_seq
	return ret

func select_from_menu(menu: Dictionary) -> Array:
	var keys = menu.keys()
	keys.shuffle()
	return keys.slice(0, 3)

func create_quadruplet(character: String):
	var state: Array[Array] = []
	state.resize(12)
	state.fill(0)
	
	var hints = select_from_menu(menu)
	for hint_seq in range(hints.size()):
		state = update_notes(state, dish2vec(hints[hint_seq], hint_seq + 1))
	
	var answers = get_possible(state)
		
	for ans in get_possible(state):
		if ans in hints:
			answers.erase(ans)
	
	hints.append(answers)
	return hints
	
func _ready():
	print(create_quadruplet(""))
	
