extends Control

signal play_again


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayAgainButton_pressed():
	emit_signal("play_again")
