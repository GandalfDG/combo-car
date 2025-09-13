extends Node2D
class_name Track

var segments: Array[TrackSegment]

func _ready():
	var segment_nodes = get_children().filter(func(node): node is TrackSegment)
	segments.assign(segment_nodes)
