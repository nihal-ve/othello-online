extends Sprite2D

@export var piece_manager: PieceManager
var PIECE_TYPE = GameManager.PIECE_TYPE

func _ready() -> void:
	piece_manager.connect("piece_played", update_turn)

func update_turn() -> void:
	var turn = GameManager.turn
	texture.region = Rect2(8*turn, 0, 8, 8)
