extends Control

var itemRecipies : Dictionary
var recipiesByRequirement : Dictionary
var recipiesByMaterial : Dictionary
var recipiesToDisplay : Array

onready var recipyList = $HBContainer/SSContainer/RecipyList
onready var craftingProgressList = $HBContainer/CraftingProgessList

const CraftRecipyButton = preload("res://Scenes/CraftRecipyButton.tscn")
const CancelRecipyButton = preload("res://Scenes/CancelRecipyButton.tscn")

signal item_created
signal request_craftable

func _ready() -> void:
	init()

func init():
	# Initialize itemRecipies
	Game.knownMaterials.append("StoneResource")
	
	for item in Game.itemData:
		if Game.itemData[item].has("Recipe"):
			itemRecipies[item] = Game.itemData[item]["Recipe"]
			
			var requirement : String = itemRecipies[item]["RequirementToLearn"]
			if (!recipiesByRequirement.has(requirement)):
				recipiesByRequirement[requirement] = []
			recipiesByRequirement[requirement].append(item)
			
			var materials : Dictionary = itemRecipies[item]["Craft"]
			for material in materials:
				if (!recipiesByMaterial.has(material)):
					recipiesByMaterial[material] = []
				recipiesByMaterial[material].append(item)
			
			var craftRecipyButton = CraftRecipyButton.instance()
			craftRecipyButton.name = item
			craftRecipyButton.texture_normal = Game.itemData[item]["Sprite"]
#			craftRecipyButton.init(self, item)
			craftRecipyButton.visible = false
			craftRecipyButton.connect("craft_recipy", self, "craft_recipy")
			recipyList.add_child(craftRecipyButton)
			set_recipy_craft_state(item, false)
	
	for item in Game.knownMaterials:
		update_recipies_to_display(item)

func refresh(item : String):
	# If this item is not a material then no changes to craft menu need to be made
	if (Game.itemData[item]["Material"] == false):
		return
	update_known_materials(item)
	update_ui(item)
#	print(item, count)
#	print(recipiesToDisplay)
#	print(recipiesByMaterial)
#	print(recipiesByRequirement)

# Needs implemented
func update_ui(item : String):
	if recipiesByMaterial.has(item):
		var recipiesToValidate : Array = recipiesByMaterial[item]
		for recipy in recipiesToValidate:
			emit_signal("request_craftable", {"ItemName" : recipy, "Recipy" : itemRecipies[recipy]["Craft"]})

func set_recipy_craft_state(recipyName : String, isCraftable : bool):
	var recipyNode = recipyList.get_node(recipyName)
	recipyNode.isCraftable = isCraftable
	if (isCraftable):
		recipyNode.modulate = Color(1, 1, 1, 1)
	else:
		recipyNode.modulate = Color(1, 1, 1, .5)

func craft_recipy(recipy : String):
	var cancelRecipyButton = CancelRecipyButton.instance()
	cancelRecipyButton.texture_normal = Game.itemData[recipy]["Sprite"]
	cancelRecipyButton.init(self, recipy, Game.itemData[recipy]["Recipe"]["CraftTime"])
	craftingProgressList.add_child(cancelRecipyButton)

func remove_from_queue(recipy : Node):
	craftingProgressList.remove_child(recipy)
	recipy.queue_free()

func finish_crafting_recipy(_o, _k, recipy : Node):
	remove_from_queue(recipy)
	emit_signal("item_created", recipy.item, Game.itemData[recipy.item]["Recipe"]["Quantity"])

func update_known_materials(item : String):
	# If we are already familiar with this item no new recipies need to be added
	if (Game.knownMaterials.has(item)):
		return
	
	# If this item is a material and we aren't familiar with it
	# Learn the material and update it's display state
	Game.knownMaterials.append(item)
	update_recipies_to_display(item)

func update_recipies_to_display(item : String):
	# Update recipiesToDisplay with all recipies this material is a RequirementToLearn for
	# This makes the recipy visible to the player and allows it's craftability state to be updated
	if recipiesByRequirement.has(item):
		for recipy in recipiesByRequirement[item]:
			recipiesToDisplay.append(recipy)
			recipyList.get_node(recipy).visible = true
