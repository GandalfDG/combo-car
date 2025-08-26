extends Node

var previous_grid

func transition_grid(new_grid):
#	for each token in the new grid, find it in the previous grid and create an
#	animation to move the token sprite to its new position
	for column in new_grid.size():
		for row in column.size():
			var new_coord = [row, column]
			var current_token = new_grid[column][row]
			
			# search the previous grid for the current_token
			
	
	previous_grid = new_grid
