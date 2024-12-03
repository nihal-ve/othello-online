extends Control

func _ready() -> void:
	if GameManager.piece_won == GameManager.PIECE_TYPE.WHITE:
		$wins.text = "WHITE\nWINS!"
	else:
		$wins.text = "BLACK\nWINS!"
	
	var white_score = GameManager.white_wins
	var black_score = GameManager.black_wins

	if white_score > 9:
		$WhiteScore.text = str(white_score)
	else:
		$WhiteScore.text = "0" + str(white_score)
	
	if black_score > 9:
		$BlackScore.text = str(black_score)
	else:
		$BlackScore.text = "0" + str(black_score)




func _on_menu_button_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	GameManager.main_menu()

func _on_again_button_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	GameManager.play_again()

func _on_exit_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().quit()

