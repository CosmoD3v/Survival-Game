extends CanvasLayer

func _ready() -> void:
	$CenterContainer/MenuGrid.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$CenterContainer/MenuGrid.visible = !$CenterContainer/MenuGrid.visible

func _on_Resume_button_up() -> void:
	$CenterContainer/MenuGrid.visible = false

func _on_Quit_button_up() -> void:
	Game.save_user_data()
	Game.scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")
