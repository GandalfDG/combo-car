extends RefCounted
class_name GridGenerator

var rows: int
var cols: int

var avg_group_size: float
var group_size_deviation: float

func _init(rows:int, cols:int, avg:float, sd:float):
	self.rows=rows
	self.cols=cols
	self.avg_group_size=avg
	self.group_size_deviation=sd

func generate_groups(group_count):
	for i in range(group_count):
		var group_size = floor(abs(randfn(0, group_size_deviation)) + group_size_deviation * 4)
		print(group_size)
		var bbox = bbox_gen(group_size)

		var group = generate_group(10)
		pass


func generate_group(group_size: int):
	var dims: Array = bbox_gen(group_size)
	var bounding_box = []
	for col in dims[1]:
		bounding_box.append([])
		for row in dims[0]:
			bounding_box[col].append(false)

	var current_coord = [0,0]
	bounding_box[0][0] = true
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
						coord_pair[0] < dims[0] and
						coord_pair[1] >= 0 and
						coord_pair[1] < dims[1]
					)
		)

		valid_coords = valid_coords.filter(func(coord_pair): return not bounding_box[coord_pair[0]][coord_pair[1]])
		current_coord = valid_coords.pick_random()
		bounding_box[current_coord[0]][current_coord[1]] = true

	return bounding_box

func bbox_gen(group_size):
	# randomly generate box width
	var width: int = randi_range(1, group_size if group_size < cols else cols)
	var height: int = ceil(group_size / width)

	return [width+1, height+1]
