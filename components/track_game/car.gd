extends Node2D
class_name Car

@export var stats: CarStats

var forward_velocity: float = 100
#var facing: Vector2 = Vector2(3, 1).normalized()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position + forward_velocity * delta * Vector2.RIGHT.rotated(rotation)
	
func steer(track_segments: Array[TrackSegment]):
	# for each segment, find the closest point on inner and outer edges
	for segment in track_segments:
		var inner_path: Path2D = segment.inner_edge
		var outer_path: Path2D = segment.outer_edge
		
		var inner_local_position = inner_path.to_local(self.global_position)
		var outer_local_position = outer_path.to_local(self.global_position)
		
		var inner_point = inner_path.curve.get_closest_point(inner_local_position)
		var outer_point = outer_path.curve.get_closest_point(outer_local_position)
		
		var inner_point_global = inner_path.to_global(inner_point)
		var outer_point_global = outer_path.to_global(outer_point)
		
		var inner_distance = self.global_position.distance_to(inner_point_global)
		var outer_distance = self.global_position.distance_to(outer_point_global)
		
		if inner_distance > outer_distance:
			rotate(.001)
		else: rotate(-.001)
		pass
