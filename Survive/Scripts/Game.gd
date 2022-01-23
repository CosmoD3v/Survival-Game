extends Node

const PLAYER_DIR = "user://Players/"
const WORLD_DIR = "user://Worlds/"

var currentPlayer : String
var itemData : Dictionary
var scene : String

# Initialize important game data
func _ready() -> void:
	scene = "MainMenu"
	itemData = load_item_data("res://Data/ItemData.json")

func change_scene(newScene : String):
	get_tree().paused = false
	var _temp = get_tree().change_scene("res://Scenes/" + newScene + ".tscn")
	scene = newScene

# Reads the item data from the disk and provides its data
func load_item_data(filePath : String):
	var jsonData
	var fileData = File.new()
	fileData.open(filePath, File.READ)
	jsonData = JSON.parse(fileData.get_as_text())
	var data = jsonData.result
	fileData.close()
	for item in data:
		data[item]["Sprite"] = load("res://Sprites/" + item + ".png")
	return data

func set_current_player(id : String):
	currentPlayer = id

# Returns a list of the names of characters existing on the computer
func get_character_names():
	var characters = []
	var dir = Directory.new()
	if !dir.dir_exists(PLAYER_DIR):
		 dir.make_dir(PLAYER_DIR)
	if dir.open(PLAYER_DIR) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if fileName.get_extension() == "json":
				characters.push_back(fileName.get_basename())
			fileName = dir.get_next()
	return characters

# Returns a list of the names of worlds existing on the computer
func get_world_names():
	var worlds = []
	var dir = Directory.new()
	if !dir.dir_exists(WORLD_DIR):
		 dir.make_dir(WORLD_DIR)
	if dir.open(WORLD_DIR) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if fileName.get_extension() == "json":
				worlds.push_back(fileName.get_basename())
			fileName = dir.get_next()
	return worlds

# Creates the file for a new character save
func create_new_character(id : String):
	var file = File.new()
	if file.open(PLAYER_DIR + id + ".json", File.WRITE) == OK:
		var data = {
			"Inventory" : {
				0 : {
					"ItemName" : "Axe",
					"ItemQuantity" : 1
				},
				1 : {
					"ItemName" : "Pickaxe",
					"ItemQuantity" : 1
				}
			}
		}
		file.store_var(data)
		file.close()

# Creates the file for a new world save
func create_new_world(id: String):
	var file = File.new()
	if file.open(WORLD_DIR + id + ".json", File.WRITE) == OK:
		file.close()

# Deletes the file for a character save
func delete_existing_character(id: String):
	var dir = Directory.new()
	if dir.open(PLAYER_DIR) == OK:
		dir.remove(id + ".json")

# Deletes the file for a world save
func delete_existing_world(id: String):
	var dir = Directory.new()
	if dir.open(WORLD_DIR) == OK:
		dir.remove(id + ".json")

# Saves the inventory to the player file on the computer
func save_user_data(inventory: Dictionary):
	var id = currentPlayer
	var file = File.new()
	if file.open(PLAYER_DIR + id + ".json", File.WRITE) == OK:
		var data = {
			"Inventory" : inventory.duplicate()
		}
		file.store_var(data)
		file.close()

# Saves the neccessary world info on the computer
#func save_world_data():
#	var id = player
#	var file = File.new()
#	if file.open(PLAYER_DIR + id + ".json", File.WRITE) == OK:
#		var data = {
#			"Inventory" : inventory.duplicate()
#		}
#		file.store_var(data)
#		file.close()

# Loads the inventory from a file on the computer
func load_user_data():
	var id = currentPlayer
	var file = File.new()
	var userData = PLAYER_DIR + id + ".json"
	if file.file_exists(userData):
		if file.open(userData, File.READ) == OK:
			var playerData = file.get_var()
			var inventory = playerData.get("Inventory")
			file.close()
			return inventory

