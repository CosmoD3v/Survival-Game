extends TextureRect

var characterMenu : Node
var characterCardName : String

func init(name : String):
	characterMenu = find_parent("CharacterMenu")
	characterCardName = name
	$Name.text = name

func _on_Play_button_up() -> void:
	Game.set_current_player(characterCardName)
	Game.change_scene("World")

func _on_Delete_button_up() -> void:
	Game.delete_existing_character(characterCardName)
	characterMenu.create_list()
