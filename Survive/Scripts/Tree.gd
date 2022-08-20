extends "res://Scripts/Resource.gd"

func addMeta():
	$InteractArea.set_meta("Resource", "Tree")

func harvest(harvestTool : String):
	match(harvestTool):
		"Axe":
			return {"Item": "WoodResource", "Quantity": 2}
		"Hand":
			return {"Item": "WoodResource", "Quantity": 1}
		_: 
			return {}
