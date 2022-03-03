extends Button
class_name GameSelectButton

export var game : PackedScene


func _on_GameSelectButton_pressed():
	get_tree().change_scene_to(game)
