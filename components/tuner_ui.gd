extends Node2D

@onready var grid: GameBoard = $Grid
@onready var option_button: OptionButton = $VBoxContainer/OptionButton
@onready var line_edit: LineEdit = $VBoxContainer/LineEdit
@onready var button: Button = $VBoxContainer/Button
var difficulties: Array

var difficulty_path = "res://game_data/difficulty/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load existing difficulties into the option button
	var listing = DirAccess.get_files_at(difficulty_path)
	for res in listing:
		difficulties.append(load(difficulty_path.path_join(res)))

	for idx in range(difficulties.size()):
		var difficulty: BoardDifficulty = difficulties[idx]
		option_button.add_item(difficulty.resource_path.get_file())
		option_button.set_item_metadata(idx, difficulty.resource_path)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	# set grid difficulty and reinitialize grid
	var difficulty_resource_path = option_button.get_item_metadata(index)
	grid.difficulty = load(difficulty_resource_path)
	grid.reset_board()
	pass # Replace with function body.


func _on_button_pressed() -> void:
	# create a new difficulty resource with the name given in line_edit
	pass # Replace with function body.
