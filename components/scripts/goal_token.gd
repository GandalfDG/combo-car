extends Token

func _init():
	type = Token.token_type.GOAL_TYPE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2), .5)
	tween.tween_callback(queue_free)
