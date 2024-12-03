extends Node2D

class_name PieceManager

var white_pieces: Dictionary
var black_pieces: Dictionary

var PIECE_TYPE = GameManager.PIECE_TYPE

@export var piece_scene: PackedScene 
@export var indicator_scene: PackedScene
@export var piece_stock: PieceStock
@export var balance_indicator: Sprite2D
@export var audio_stream: AudioStreamPlayer

signal piece_played

func add_piece(grid_pos: Vector2, piece_type: GameManager.PIECE_TYPE) -> void:
	if grid_pos in white_pieces or grid_pos in black_pieces:
		return
	if grid_pos.x > 7 or grid_pos.x < 0 or grid_pos.y > 7 or grid_pos.y < 0:
		return
	
	var current_dict = white_pieces if piece_type == PIECE_TYPE.WHITE else black_pieces
	
	var new_piece = piece_scene.instantiate()
	new_piece.piece_type = piece_type
	new_piece.global_position = GameManager.grid_to_world(grid_pos)

	current_dict[grid_pos] = new_piece
	add_child(new_piece)

func check_flip(grid_pos: Vector2, piece_type: GameManager.PIECE_TYPE, flip: bool = false):
	var dirs = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1),
		Vector2(1, -1),
		Vector2(-1, -1),
		Vector2(-1, 1),
		Vector2(1, 1),
	]

	var my_dict = white_pieces if piece_type == PIECE_TYPE.WHITE else black_pieces
	var oppo_dict = black_pieces if piece_type == PIECE_TYPE.WHITE else white_pieces

	if !flip:
		for dir in dirs:
			var opposite_piece = false
			for i in range(10):
				var check_pos = grid_pos + (i+1) * dir
				if check_pos in my_dict and opposite_piece == false: # Touching same piece
					break
				elif check_pos not in my_dict and check_pos not in oppo_dict: # Touching no piece
					break
				elif check_pos in my_dict and opposite_piece == true: # Same to oppo piece
					return true
				elif check_pos in oppo_dict:
					opposite_piece = true

		return false
	else:
		var flip_pieces = []
		for dir in dirs:
			var need_to_flip = []
			var opposite_piece = false
			for i in range(10):
				var check_pos = grid_pos + (i+1) * dir
				if check_pos in my_dict and opposite_piece == false: # Touching same piece
					break
				elif check_pos not in my_dict and check_pos not in oppo_dict: # Touching no piece
					break
				elif check_pos in my_dict and opposite_piece == true: # Same to oppo piece
					for piece in need_to_flip:
						flip_pieces.append(piece)
					break
				elif check_pos in oppo_dict:
					opposite_piece = true
					need_to_flip.append(check_pos)

		return flip_pieces

func find_moves(piece_type: GameManager.PIECE_TYPE, visualize: bool = true) -> Array[Vector2]:
	if visualize:
		for child in get_children():
			if child.is_in_group("indicator"):
				child.queue_free()

	var moves: Array[Vector2] = []

	for y in range(8):
		for x in range(8):
			var move_pos = Vector2(x, y)

			if move_pos in white_pieces or move_pos in black_pieces:
				continue
			
			var dirs = [
				Vector2(1, 0),
				Vector2(0, 1),
				Vector2(-1, 0),
				Vector2(0, -1),
				Vector2(1, -1),
				Vector2(-1, -1),
				Vector2(-1, 1),
				Vector2(1, 1),
			]

			var touching = false
			for dir in dirs:
				if (move_pos + dir) in white_pieces or (move_pos + dir) in black_pieces:
					touching = true
					break
			
			if !touching:
				continue
			
			if !check_flip(move_pos, piece_type):
				continue

			if visualize:
				var indicator = indicator_scene.instantiate()
				indicator.global_position = GameManager.grid_to_world(move_pos)
				add_child(indicator)

			moves.append(move_pos)
	return moves

var possible_moves: Array[Vector2]

func _ready() -> void:
	add_piece(Vector2(3, 3), PIECE_TYPE.WHITE)
	add_piece(Vector2(3, 4), PIECE_TYPE.BLACK)
	add_piece(Vector2(4, 4), PIECE_TYPE.WHITE)
	add_piece(Vector2(4, 3), PIECE_TYPE.BLACK)

	possible_moves = find_moves(PIECE_TYPE.BLACK)

func _process(delta: float) -> void:

	if len(possible_moves) == 0:
		GameManager.flip_turn()
		possible_moves = find_moves(GameManager.turn)
		emit_signal("piece_played")

	if Input.is_action_just_pressed("mouse_left"):
		var mouse_position = get_global_mouse_position()
		var tile_pos = GameManager.world_to_grid(mouse_position)

		if tile_pos in possible_moves:
			var current_piece = GameManager.turn
			add_piece(tile_pos, current_piece)

			audio_stream.pitch_scale = randf_range(0.93, 1.07)
			audio_stream.play()
			await audio_stream.finished

			var flips = check_flip(tile_pos, current_piece, true)

			var my_dict = white_pieces if current_piece == PIECE_TYPE.WHITE else black_pieces
			var oppo_dict = black_pieces if current_piece == PIECE_TYPE.WHITE else white_pieces

			for flip in flips:
				var piece = oppo_dict[flip]
				piece.flip()
				oppo_dict.erase(flip)
				my_dict[flip] = piece

			GameManager.flip_turn()
			possible_moves = find_moves(GameManager.turn)

			piece_stock.remove_piece()

			emit_signal("piece_played")
			balance_indicator.material.set_shader_parameter("balance", float(len(white_pieces))/float(len(black_pieces)+len(white_pieces)))
			
			check_game_over()

func check_game_over():
	if len(white_pieces) + len(black_pieces) == 64:
		if len(white_pieces) > len(black_pieces):
			GameManager.game_over(PIECE_TYPE.WHITE)
		else:
			GameManager.game_over(PIECE_TYPE.BLACK)
	
	elif len(white_pieces) == 0:
		GameManager.game_over(PIECE_TYPE.BLACK)
	elif len(black_pieces) == 0:
		GameManager.game_over(PIECE_TYPE.WHITE)

	elif len(find_moves(PIECE_TYPE.WHITE, false)) == 0 and len(find_moves(PIECE_TYPE.BLACK, false)) == 0:
		if len(white_pieces) > len(black_pieces):
			GameManager.game_over(PIECE_TYPE.WHITE)
		else:
			GameManager.game_over(PIECE_TYPE.BLACK)
