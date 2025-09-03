extends Resource
class_name BoardDifficulty

@export
var time_limit: float = 30.0

@export
var refill_count: int = 50

@export_range(3, 20, 1, "or_greater")
var columns: int = 5

@export_range(3, 20, 1, "or_greater")
var rows: int = 5

@export_range(1, 10, 1, "or_greater")
var goal_count: int = 3

@export_range(0, 10, 1, "or_greater")
var refill_friendliness: int = 3

@export
var group_sizes: Array[int] = []
