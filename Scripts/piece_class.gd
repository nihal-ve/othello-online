extends Node2D
class_name PieceClass

@onready var piece_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var piece_type: GameManager.PIECE_TYPE

func _ready() -> void:
	color_piece()

func color_piece() -> void:
	piece_sprite.frame = piece_type*4

func flip() -> void:
	if piece_type == GameManager.PIECE_TYPE.WHITE:
		$AnimatedSprite2D.play_backwards()
	else:
		$AnimatedSprite2D.play()
	piece_type = GameManager.PIECE_TYPE.WHITE if piece_type == GameManager.PIECE_TYPE.BLACK else GameManager.PIECE_TYPE.BLACK