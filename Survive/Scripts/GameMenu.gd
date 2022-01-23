extends Control

var player: Node

func _ready() -> void:
	player = find_parent("Player")
	$CenterContainer.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$CenterContainer/MenuGrid.visible = !$CenterContainer/MenuGrid.visible
		get_tree().paused = !get_tree().paused

func _on_Resume_button_up() -> void:
	$CenterContainer/MenuGrid.visible = false
	get_tree().paused = !get_tree().paused

func _on_Quit_button_up() -> void:
	Game.save_user_data(player.inventoryNode.inventory)
	Game.change_scene("MainMenu")
