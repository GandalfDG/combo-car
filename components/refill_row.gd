extends Node2D

var offset = 60
var refill_row: Array[Token]

func init(token_offset: int):
	offset = token_offset

func push_refills(refill_tokens: Array[Token]):
	refill_row = refill_tokens
	redraw_refills()

func pop_refills() -> Array[Token]:
	return refill_row

func redraw_refills():
	for idx in range(refill_row.size()):
		var token = refill_row[idx]
		token.position = Vector2(idx * offset, 0)
		token.debug_label.text = str(idx)
		token.set_highlighted(false)
