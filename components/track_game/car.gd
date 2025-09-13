extends Node2D
class_name Car

@export var stats: CarStats

var forward_velocity: float = 100
var facing: Vector2 = Vector2(3, 1).normalized()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position + forward_velocity * delta * facing
	
func steer(track_segments: Array[TrackSegment]):
	# for each segment, find the closest point on inner and outer edges
	for segment in track_segments:
		pass
		
