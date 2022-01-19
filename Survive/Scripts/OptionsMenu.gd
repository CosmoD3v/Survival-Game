extends Control


onready var button = $CenterContainer/TabContainer/Graphics/GridContainer/Button
var fullscreen : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	button.text = "Fullscreen Off"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_button_up():
	Game.change_scene("MainMenu")


func _on_Button_button_up():
	change_fullscreen()

func change_fullscreen():
	fullscreen = not fullscreen
	if fullscreen:
		button.text = "Fullscreen On"
	else:
		button.text = "Fullscreen Off"
	OS.window_fullscreen = fullscreen
