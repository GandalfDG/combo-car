extends Resource
class_name BoardDifficulty

@export
var time_limit: float = 30.:
	set(value):
		time_limit=value
		emit_changed()

@export
var refill_count: int = 50:
	set(value):
		refill_count=value
		emit_changed()

@export_range(3, 20, 1, "or_greater")
var columns: int = 5:
	set(value):
		columns=value
		emit_changed()

@export_range(3, 20, 1, "or_greater")
var rows: int = 5:
	set(value):
		rows=value
		emit_changed()
		
@export_range(8, 20, 1, "or_greater")
var max_row: int = 10:
	set(value):
		max_row=value
		emit_changed()

@export_range(1, 10, 1, "or_greater")
var goal_count: int = 3:
	set(value):
		goal_count=value
		emit_changed()

@export_range(0, 1, 0.05, "or_greater")
var refill_friendliness: float = 0.5:
	set(value):
		refill_friendliness=value
		emit_changed()

@export
var group_sizes: Array[int] = []:
	set(value):
		group_sizes=value
		emit_changed()
