extends Node

const SCALE = 8
enum PIECE_TYPE {BLACK, WHITE, BOTH}

var turn: PIECE_TYPE = PIECE_TYPE.BLACK

@onready var end_screen = preload("res://Scenes/end_screen.tscn")
@onready var game_screen = preload("res://Scenes/main.tscn")
@onready var menu_screen = preload("res://Scenes/main_menu.tscn")
var piece_won: int

var black_wins: int = 0
var white_wins: int = 0

func grid_to_world(grid_pos: Vector2) -> Vector2:
	return grid_pos * 64 + Vector2(32, 32)

func world_to_grid(world_pos: Vector2) -> Vector2:
	return round((world_pos - Vector2(48, 48)) / 64)

func flip_turn():
	turn = PIECE_TYPE.WHITE if turn == PIECE_TYPE.BLACK else PIECE_TYPE.BLACK

func game_over(piece_type: PIECE_TYPE) -> void:
	if piece_type == PIECE_TYPE.BLACK:
		black_wins += 1
	else:
		white_wins += 1

	piece_won = piece_type
	get_tree().change_scene_to_packed(end_screen)

func play_again() -> void:
	turn = PIECE_TYPE.BLACK
	get_tree().change_scene_to_packed(game_screen)

func main_menu() -> void:
	get_tree().change_scene_to_packed(menu_screen)