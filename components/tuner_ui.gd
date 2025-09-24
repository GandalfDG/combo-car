extends Node2D

@onready var option_button: OptionButton = $VBoxContainer/OptionButton
var difficulties: Array

var difficulty_path = "res://game_data/difficulty/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load existing difficulties into the option button
	var listing = DirAccess.get_files_at(difficulty_path)
	for res in listing:
		difficulties.append(load(difficulty_path.path_join(res)))

	print(difficulties)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.
