extends Node2D

@export_range(1, 20, 1, "or_greater") var rows: int = 5
@export_range(1, 20, 1, "or_greater") var cols: int = 5
@export_range(1, 5, 1, "or_greater") var min_group_size: int = 3

@export var offset: int = 55
@export var refill_offset: int = 30

@onready
var grid_area: Area2D = $InteractionArea

@onready
var grid_shape: CollisionShape2D = $InteractionArea/BoundaryShape

@onready
var refill_row = $RefillRow

var grid: Grid
var groups: Array
var hovered_group: Array

var debug_label: Label
var grid_gen: GridGenerator

var token = preload("res://components/token.tscn")
var goal_token = preload("res://components/goal_token.tscn")

func _ready():
	debug_label = $"Debug Label"
	#grid_gen = GridGenerator.new(5, 5, 1, 2)
	#grid_gen.generate_groups(10)

	grid_area.position = Vector2(cols * offset / 2, rows * offset / 2)
	grid_shape.shape.size = Vector2(cols * offset, rows * offset)

	# position the refill row below the grid
	refill_row.init(offset)
	refill_row.position = Vector2(0, rows * offset + refill_offset)

	grid = Grid.new(rows, cols, null)

	generate_board()
	generate_refills()

	redraw_grid()
	calculate_token_groups()

func _process(_delta: float) -> void:
	clear_highlights()

	# get mouse position for hover
	var mouse_position = self.get_local_mouse_position()
	if not pixel_within_grid(mouse_position):
		return

	var coord_under_mouse = pixel_to_grid_coord(mouse_position)
	var token_under_mouse: Token = grid.get_element(coord_under_mouse[0], coord_under_mouse[1])

	if token_under_mouse != null:
		var group = get_group_of_token(coord_under_mouse)
		if group.size() >= min_group_size:
			highlight_group(group, true)



	# if click, determine token clicked
func pixel_within_grid(coord: Vector2) -> bool:
	return (coord.x >= 0 and coord.x < cols * offset and
					coord.y >= 0 and coord.y < rows * offset)

func pixel_to_grid_coord(coord: Vector2) -> Array[int]:
	return [coord.y / offset, coord.x / offset]

func generate_board():
	for column in cols:
		for row in range(rows-1, 1, -1):
			var token_node: Token = token.instantiate()
			add_child(token_node)
			token_node.set_type(randi_range(0,3) as Token.token_type)
			grid.set_element(row, column, token_node)
		
	for column in grid.grid_container:
		var token = goal_token.instantiate()
		add_child(token)
		column[0] = token

func generate_refills():
	var refills: Array[Token] = []
	for column in cols:
		var token_node: Token = token.instantiate()
		refill_row.add_child(token_node)
		token_node.set_type(randi_range(0,3) as Token.token_type)
		refills.append(token_node)

	refill_row.push_refills(refills)

func load_refills():
	var refills: Array[Token] = refill_row.pop_refills()
	for idx in range(cols):
		refills[idx].reparent(self)
		var column = grid.get_column(idx)
		column.push_back(refills[idx])
		var leaving_token = column.pop_front()
		if leaving_token != null:
			leaving_token.destroy()

	update_grid()

func highlight_group(group: Array, enable: bool):

	for coord in group:
		var current_token = grid.get_element(coord[0], coord[1])
		if current_token == null: continue
		current_token.set_highlighted(enable)

	hovered_group = group

func clear_highlights():
	grid.element_apply(func(el): if el != null: el.set_highlighted(false))

func update_grid():
#	search for empty columns and compact horizontally
	var temp_grid = grid.grid_container.filter(func(col: Array): return !col.all(func(token): return token == null))

	var arr = []
	arr.resize(rows)
	arr.fill(null)
	for _i in range(cols - temp_grid.size()):
		temp_grid.append(arr.duplicate())

	grid.grid_container = temp_grid

#	search for empty cells and drop tokens above them down
	var temp_col
	grid.column_apply(func(column): 
		temp_col = column.filter(func(token): return token != null)
		for idx in range(rows - temp_col.size()):
			column[idx] = null
		for idx in range(temp_col.size()):
			column[rows-temp_col.size() + idx] = temp_col[idx]
	)
			

	redraw_grid()
	calculate_token_groups()

func redraw_grid():
	grid.element_apply_coord(func(element: Token, row, col):
			if element == null:
				return
			
			element.set_debug_label(str(row) + "," + str(col))
			element.update_position(Vector2(offset*col, offset*row))
	)			

func calculate_token_groups():
	groups = []
	var visited_nodes = []
	var group_queue = []
	for row in rows:
		for col in cols:
			if [row, col] in visited_nodes or grid.get_element(row, col) == null:
				continue

			group_queue.append([row,col])

			var new_group = []
			while not group_queue.is_empty():
				var current_coord = group_queue.pop_back()
				var current_token = grid.get_element(current_coord[0], current_coord[1])
				new_group.append(current_coord)
				visited_nodes.append(current_coord)

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

				for coord in valid_coords:
					var token = grid.get_element(coord[0],coord[1])
					if (token != null and
							coord not in visited_nodes and
							token.type == current_token.type and
							coord not in group_queue):
						group_queue.append(coord)
			groups.append(new_group)

	debug_label.text = str(groups)

func get_group_of_token(token_coord) -> Array:
	for group in groups:
		if token_coord in group:
			return group

	return []


func _on_boundary_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		var position = self.get_local_mouse_position()
		var token_coord = pixel_to_grid_coord(position)
		var group = get_group_of_token(token_coord)
		if group.size() >= min_group_size:
			for coord in group:
				var current_token = grid.get_element(coord[0], coord[1])
				if current_token != null: current_token.destroy()
				grid.set_element(coord[0], coord[1], null)# do I actually want a null value or should there be some other placeholder?

			update_grid()

func _input(event):
		# check input to load refills
	if event.is_action_pressed("activate"):
		load_refills()
		generate_refills()
