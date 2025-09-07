extends Node2D

var offset = 60
var refill_row: Array[Token]

var token_scene = preload("res://components/token.tscn")

func init(token_offset: int):
	offset = token_offset
	
func generate_refills(grid: Grid, friendliness: float):
	# friendliness can be a guarantee of some percent of tokens
	# matching the bottom row, it can also be smarter with tokens
	# that will create a group when there wasn't already
	# and beyond that even aiming for columns that will cause a goal to clear
	refill_row = []
	var guaranteed_match_count = ceil(friendliness * grid.cols)
	
	var bottom_row = grid.get_row(grid.rows - 1)
	var index_bag = range(grid.cols)
	
	# select indices for guaranteed matches
	var guaranteed_indices =  []
	for i in guaranteed_match_count:
		var index = index_bag.pick_random()
		index_bag.remove_at(index_bag.find(index))
		
		guaranteed_indices.append(index)
		
	for idx in grid.cols:
		var new_token = token_scene.instantiate()
		if idx in guaranteed_indices and bottom_row[idx] != null:
			new_token.type = bottom_row[idx].type
		else:
			new_token.type = randi_range(0,3) as Token.token_type
			
		add_child(new_token)
		refill_row.append(new_token)
			
	redraw_refills()
		

func push_refills(refill_tokens: Array[Token]):
	refill_row = refill_tokens
	redraw_refills()

func pop_refills() -> Array[Token]:
	return refill_row

func redraw_refills():
	for idx in range(refill_row.size()):
		var token = refill_row[idx]
		token.position = Vector2(idx * offset, 0)
		token.debug_label.text = str(idx)
		token.set_highlighted(false)
