extends Node2D

var track: Track
var cars: Array[Car]
var player_car: Car


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var car_nodes = get_children().filter(func(node): return node is Car)
	cars.assign(car_nodes)
	
	track = $Track
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_cars()
	
func update_cars():
	# tell each car what it needs to know
	# current assumptions:
	# pass a car a reference to the track segment it's on and let it drive itself for a timestep
	# then resolve collisions at this level?
	for car in cars:
		var track_segments = find_car_segments(car)
		car.steer(track_segments)
	
	pass
	
func find_car_segments(car: Car) -> Array[TrackSegment]:
	var car_collider: Area2D = car.get_node("Sprite2D/Area2D")
	
	var overlapping_areas = car_collider.get_overlapping_areas()
	var segments: Array[TrackSegment] = []
	for area in overlapping_areas:
		var parent = area.get_parent() as TrackSegment
		if parent == null: continue
		segments.append(parent)
		
		
	return segments
