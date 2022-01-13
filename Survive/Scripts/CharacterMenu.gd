extends Control

var CharacterCard = preload("res://Scenes/CharacterCard.tscn")
onready var CharacterList = $SelectMenu/Scroll/CharacterList

func _ready() -> void:
	create_list()

# Updates the character list based on the player save files
func create_list():
	$SelectMenu/Scroll.scroll_vertical = 0
	for child in CharacterList.get_children():
		CharacterList.remove_child(child)
		child.queue_free()
	var names = Game.get_character_names()
	for name in names:
		var card = CharacterCard.instance()
		card.init(name)
		CharacterList.add_child(card)

func show_select():
	$SelectMenu.visible = true
	$CreateMenu.visible = false

func show_create():
	$SelectMenu.visible = false
	$CreateMenu.visible = true

func clear_text_bar():
	$CreateMenu/TextBar.text = ""

func _on_New_button_up() -> void:
	show_create()

func _on_Cancel_button_up() -> void:
	show_select()
	clear_text_bar()

func _on_Accept_button_up() -> void:
	var name = $CreateMenu/TextBar.text
	name = name.strip_escapes()
	name = name.strip_edges()
	if name != "" && !Game.get_character_names().has(name):
		Game.create_new_character(name)
		create_list()
		show_select()
		clear_text_bar()
	else:
		# Tell user to pick a different name
		pass

func _on_Back_button_up() -> void:
# warning-ignore:return_value_discarded
	Game.scene = get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass
