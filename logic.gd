extends Node2D

func update_notes(state: Array[int], update: Array[int]) -> Array[int]:
	# State is a vector with all known order information in it
	# This function pushes an update (e.g., a whole dish, one tag) to state
	
	# 0 NO
	# 1 YES
	# 2 Possible trait
	for i in range(update.size()):
		if update[i] != 2:
			state[i] = update[i]
	return state
	
func get_possible(state: Array[int], pool: Array) -> Array:
	# Given a state, find all dishes in the pool that the state could describe
	# This should be used to check answers, or to guide the search engine
	
	var ret = []
	for dish in pool:
		var flag = false
		
		for i in range(state.size()):
			if state[i] == 2:
				continue
			if dish[i] != state[i]:
				flag = true
		
		if not flag:
			ret.append(dish)
	
	return ret
