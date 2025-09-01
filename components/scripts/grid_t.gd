extends RefCounted
class_name Grid

var rows: int
var cols: int
var grid_container

func _init(rows: int, columns: int, default_value):
	self.rows = rows
	self.cols = columns
	for column in columns:
		grid_container.append([])
		for row in rows:
			grid_container[column].append(null)

func get_element(row: int, column: int):
	return grid_container[column][row]

func set_element(row: int, column: int, value):
	grid_container[column][row] = value

func get_column(column):
	return grid_container[column]

func get_row(row):
	var row_arr = []
	for column in grid_container:
		row_arr.append(column[row])

	return row_arr
