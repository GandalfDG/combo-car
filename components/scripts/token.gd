extends Node2D
class_name Token

enum token_type {TYPE_1, TYPE_2, TYPE_3, TYPE_4, GOAL_TYPE}
enum token_state {NONE, HIGHLIGHT}

var type: token_type
var state: token_state = token_state.NONE


var color_polygon: Polygon2D
var highlight_polygon: Polygon2D
var debug_label: Label

func _ready():
	color_polygon = $Color
	highlight_polygon = $highlight_indicator
	debug_label = $"Debug Label"
	set_token_display()

func set_token_display():
		match self.type:
			token_type.TYPE_1:
				color_polygon.color = Color.RED
			token_type.TYPE_2:
				color_polygon.color = Color.GREEN
			token_type.TYPE_3:
				color_polygon.color = Color.BLUE
			token_type.TYPE_4:
				color_polygon.color = Color.GOLD

func set_debug_label(text: String):
	debug_label.text = text

func update_position(new_position: Vector2):
	var distance = abs(new_position - position)

	var tweener: Tween = self.create_tween()
	tweener.tween_property(self, "position:y", new_position.y, 0.005 * distance.y)
	tweener.tween_property(self, "position:x", new_position.x, 0.0005 * distance.x)

func set_highlighted(highlight: bool):
	state = token_state.HIGHLIGHT if highlight else token_state.NONE
	match state:
		token_state.HIGHLIGHT:
			highlight_polygon.visible = true
		token_state.NONE:
			highlight_polygon.visible = false

func destroy():
	# TODO animate token destruction
	self.queue_free()
