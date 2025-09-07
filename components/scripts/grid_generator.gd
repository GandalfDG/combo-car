extends RefCounted
class_name GridGenerator

var token_scene = preload("res://components/token.tscn")
var goal_scene = preload("res://components/goal_token.tscn")

var rows: int
var cols: int
var max_rows: int

var grid: Grid


func _init(rows:int, cols:int, max_rows:int):
	self.rows=rows
	self.cols=cols
	self.max_rows = max_rows
	
	grid = Grid.new(rows, cols, null)

func generate_board(group_sizes: Array[int], token_parent: Node, goal_count: int):
	for size in group_sizes:
		#generate_group(size, Token.token_type.TYPE_3)
		generate_group(size, randi_range(0,3) as Token.token_type)

	grid.element_apply_coord(func(element, row, col): if element == null:
		var new_token: Token = token_scene.instantiate()
		new_token.type = randi_range(0,3) as Token.token_type
		grid.set_element(row, col, new_token)
		)

	grid.element_apply(func(element): if element != null: token_parent.add_child(element))
	grid.add_rows(max_rows - rows, null)
	
	var goal_idx_bag = range(cols)
	var goal_indices = []
	for _i in goal_count:
		var idx = goal_idx_bag.pick_random()
		goal_idx_bag.remove_at(goal_idx_bag.find(idx))
		goal_indices.append(idx)
		
	for idx in goal_indices:
		var goal_node = goal_scene.instantiate()
		token_parent.add_child(goal_node)
		grid.set_element(max_rows - rows - 1, idx, goal_node)
		
	return grid

func generate_group(group_size: int, token_type: Token.token_type):

	# find an empty space to start
	var start_coord = null
	while start_coord == null:
		var row_coord = randi_range(0, rows-1)
		var col_coord = randi_range(0, cols-1)
		if grid.get_element(row_coord, col_coord) == null:
			start_coord = [row_coord, col_coord]

#	walk to adjacent empty squares to create a group
	var current_coord = start_coord
	for idx in group_size:
		# valid neighbor cells
		var adjacent_token_coords = [
					[current_coord[0] - 1, current_coord[1]],
					[current_coord[0], current_coord[1] + 1],
					[current_coord[0] + 1, current_coord[1]],
					[current_coord[0], current_coord[1] - 1]
				]

		var valid_coords = adjacent_token_coords.filter(
				func(coord_pair):
					return (
						coord_pair[0] >= 0 and
						coord_pair[0] < rows and
						coord_pair[1] >= 0 and
						coord_pair[1] < cols
					)
		)

		valid_coords = valid_coords.filter(func(coord_pair): return not grid.get_element(coord_pair[0], coord_pair[1]))
		if valid_coords.size() < 1: break
		current_coord = valid_coords.pick_random()
		var new_token: Token = token_scene.instantiate()
		new_token.type=token_type
		grid.set_element(current_coord[0], current_coord[1], new_token)
