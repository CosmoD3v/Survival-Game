extends "res://Scripts/Resource.gd"

func harvest(inventory):
	if Game.inventory.has(Game.hotbarSelected):
		if Game.inventory[Game.hotbarSelected]["ItemName"] == "Axe":
			inventory.add_item("Wood", 1)
