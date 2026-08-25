func score(selection: Array[int], truth: Array[int]) -> int:
	# Each dish is represented as a one-hot vector of qualities
	
	# This function counts the number of matches
	# 2 = both True, 0 = both False
	
	# If we end up creating lots of possible traits, these one-hot vectors may be sparse
	# For now, I'll count positive matches (True-True), but not negative matches (False-False) 
	var comparison = selection + truth
	return comparison.count(2)
	
func generate_order(truth: Array[int], pool: Array[Array], min_df: int, max_df: int) -> Array[Array]:
	# Filter all dishes by a specific range of matching qualities. This way, different clients
	# can have different behavior
	var possible = []
	
	for dish in pool:
		if min_df < score(dish, truth) and score(dish, truth) < max_df:
			possible.append(dish)
			
	return possible
