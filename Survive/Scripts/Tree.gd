extends "res://Scripts/Resource.gd"

func addMeta():
	$InteractArea.set_meta("Resource", "Tree")

func harvest(inventoryNode : Node):
	var inventory = inventoryNode.inventory
	if inventory.has(inventoryNode.hotbarSelected):
		if inventory[inventoryNode.hotbarSelected]["ItemName"] == "Axe":
			inventoryNode.add_item("WoodResource", 1)
