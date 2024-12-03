extends Label

@export var piece_manager: PieceManager
@export_enum("WHITE", "BLACK") var PIECE_TYPE

func _ready() -> void:
	piece_manager.connect("piece_played", update_score)

func update_score() -> void:
	var dict = piece_manager.white_pieces if PIECE_TYPE == 0 else piece_manager.black_pieces
	var score = len(dict)

	if score > 9:
		text = str(score)
	else:
		text = "0" + str(score)
