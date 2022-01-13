extends Node

const PLAYER_DIR = "user://Players/"

var player: String
var inventory: Dictionary
var itemData: Dictionary
var hotbarSelected: int
var scene = null

# Initialize important game data
func _ready() -> void:
	scene = get_tree().current_scene
	itemData = load_item_data("res://Data/ItemData.json")

# Reads the item data from the disk and provides its data
func load_item_data(filePath):
	var jsonData
	var fileData = File.new()
	fileData.open(filePath, File.READ)
	jsonData = JSON.parse(fileData.get_as_text())
	fileData.close()
	return jsonData.result

# Returns a list of the names of characters existing on the computer
func get_character_names():
	var characters = []
	var dir = Directory.new()
	if dir.open(PLAYER_DIR) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if fileName.get_extension() == "json":
				characters.push_back(fileName.get_basename())
			fileName = dir.get_next()
	return characters

# Creates the file for a new character save
func create_new_character(id):
	var file = File.new()
	if file.open(PLAYER_DIR + id + ".json", File.WRITE) == OK:
		var data = {
			"inventory" : {
				0 : ["Axe", 1]
			}
		}
		file.store_var(data)
		file.close()

# Deletes the file for a character save
func delete_existing_character(id):
	var dir = Directory.new()
	if dir.open(PLAYER_DIR) == OK:
		dir.remove(id + ".json")

# Saves the inventory to the player file on the computer
func save_user_data():
	var id = player
	var file = File.new()
	if file.open(PLAYER_DIR + id + ".json", File.WRITE) == OK:
		var data = {
			"inventory" : inventory.duplicate()
		}
		file.store_var(data)
		file.close()

# Loads the inventory from a file on the computer
func load_user_data(id: String):
	hotbarSelected = 0
	player = id
	var file = File.new()
	var userData = PLAYER_DIR + id + ".json"
	if file.file_exists(userData):
		if file.open(userData, File.READ) == OK:
			var playerData = file.get_var()
			inventory = playerData.get("inventory")
			file.close()