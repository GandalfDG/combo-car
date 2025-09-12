extends RefCounted
class_name Grid

var rows: int
var cols: int
var grid_container: Array[Array] = []

func _init(rows: int, columns: int, default_value: Variant):
	self.rows = rows
	self.cols = columns
	for column in columns:
		grid_container.append([])
		for row in rows:
			grid_container[column].append(default_value)

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

func element_apply(fn: Callable):
	for col in grid_container:
		for element in col:
			fn.call(element)

func element_apply_coord(fn: Callable):
	for col in cols:
		for row in rows:
			fn.call(get_element(row, col), row, col)

func column_apply(fn: Callable):
	for col in grid_container:
		fn.call(col)

func add_rows(row_count: int, value: Variant):
	var append = []
	append.resize(row_count)
	append.fill(value)
	for col_idx in grid_container.size():
		var new_col = append.duplicate()
		new_col.append_array(grid_container[col_idx])
		grid_container[col_idx] = new_col

	self.rows += row_count
