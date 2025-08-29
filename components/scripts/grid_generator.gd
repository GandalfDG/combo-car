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
		
		var group = generate_group(bbox[0], bbox[1])
		
		
func generate_group(bbox_x:int, bbox_y:int):
	var bounding_box = []
	for col in bbox_y:
		bounding_box.append([])
		for row in bbox_x:
			bounding_box[col].append(null)
			
func bbox_gen(group_size):
	# randomly generate box width
	var width: int = randi_range(1, group_size if group_size < cols else cols)
	var height: int = ceil(group_size / width)
	
	return [width, height]
