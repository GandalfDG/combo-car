extends RefCounted
class_name GridGenerator

var token_scene = preload("res://components/token.tscn")

var rows: int
var cols: int

var grid: Grid


func _init(rows:int, cols:int, avg:float, sd:float):
	self.rows=rows
	self.cols=cols
	self.avg_group_size=avg
	self.group_size_deviation=sd
	
	grid = Grid.new(rows, cols, null)
	
func generate_board(group_sizes: Array[int]):
	for size in group_sizes:
		generate_group(size, Token.token_type.TYPE_1)
		
	grid.element_apply(func(element): if element == null: 
		var new_token: Token = token_scene.instantiate()
		new_token.set_type(randi_range(0,3) as Token.token_type)
		element = new_token
		)
		
	return grid

func generate_group(group_size: int, token_type: Token.token_type):
	
	# find an empty space to start
	var start_coord = null
	while start_coord == null:
		var row_coord = randi_range(0, rows)
		var col_coord = randi_range(0, cols)
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
		new_token.set_type(token_type)
		grid.set_element(current_coord[0], current_coord[1], new_token)
