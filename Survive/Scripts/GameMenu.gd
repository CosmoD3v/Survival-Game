extends CanvasLayer

var player: Node

func _ready() -> void:
	player = find_parent("Player")
	$CenterContainer.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$CenterContainer.visible = !$CenterContainer.visible

func _on_Resume_button_up() -> void:
	$CenterContainer.visible = false
	
func _on_Options_button_up():
	$OptionsMenu.visible = not $OptionsMenu.visible
	$CenterContainer.visible = false

func _on_Quit_button_up() -> void:
	Game.save_user_data(player.inventoryNode.inventory)
	Game.change_scene("MainMenu")
