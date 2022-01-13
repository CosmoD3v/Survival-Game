extends GridContainer

func _ready() -> void:
	pass

func _on_Quit_button_up() -> void:
	get_tree().quit()

func _on_Play_button_up() -> void:
	Game.scene = get_tree().change_scene("res://Scenes/CharacterMenu.tscn")
