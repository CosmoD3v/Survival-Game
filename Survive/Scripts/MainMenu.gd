extends GridContainer

func _ready() -> void:
	pass

func _on_Quit_button_up() -> void:
	get_tree().quit()

func _on_Play_button_up() -> void:
	Game.change_scene("CharacterMenu")

func _on_Options_button_up():
	Game.change_scene("OptionsMenu")
