extends TextureRect

onready var CharacterMenu = get_parent().get_parent().get_parent().get_parent()
var CharacterName

func init(name):
	CharacterName = name
	$Name.text = name

func _on_Play_button_up() -> void:
	Game.load_user_data(CharacterName)
	Game.set_scene("World")

func _on_Delete_button_up() -> void:
	Game.delete_existing_character(CharacterName)
	CharacterMenu.create_list()
