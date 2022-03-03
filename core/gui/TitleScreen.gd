extends CenterContainer
class_name TitleScreen


func _on_PlayButton_pressed():
	get_tree().change_scene_to(preload("res://core/game/una/Una.tscn"))
