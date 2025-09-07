extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_board_goal_cleared() -> void:
	print("goal token cleared")


func _on_game_board_group_cleared(size: Variant, type: Variant) -> void:
	print("group of size " + str(size) + " cleared")


func _on_game_board_token_overflowed(type: Token.token_type) -> void:
	print("token overflowed")


func _on_game_board_goal_overflowed() -> void:
	print("goal overflowed")
