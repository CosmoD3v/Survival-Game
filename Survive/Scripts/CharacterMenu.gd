extends Control

onready var characterList = $SelectMenu/Scroll/CharacterList
var characterCard = preload("res://Scenes/CharacterCard.tscn")

func _ready() -> void:
	create_list()

# Updates the character list based on the player save files
func create_list():
	$SelectMenu/Scroll.scroll_vertical = 0
	for child in characterList.get_children():
		characterList.remove_child(child)
		child.queue_free()
	var names = Game.get_character_names()
	for name in names:
		var card = characterCard.instance()
		characterList.add_child(card)
		card.init(name)

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
	Game.change_scene("MainMenu")
