extends Sprite2D

class_name PieceStock

@export_range(0, 64) var remaining_pieces: int = 64

func remove_piece() -> void:
	if remaining_pieces == 0:
		return
	remaining_pieces -= 1
	if remaining_pieces % 2 == 0:
		texture.region = Rect2(0, 0, remaining_pieces, 6)
		global_position.x -= GameManager.SCALE

func _ready() -> void:
	for i in range(4):
		remove_piece()
