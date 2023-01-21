extends Node2D

var itemName : String
var itemQuantity : int

func _ready() -> void:
	pass

# Uses Json data to initialize the item or initializes it as null if it's empty
#func init(name : String, quantity : int):
#	var stackSize
#	itemName = name
#	itemQuantity = quantity
#	$Texture.texture = Game.itemData[itemName]["Sprite"]
#	stackSize = int(Game.itemData[itemName]["StackSize"])
#
#	if stackSize == 1:
#		$Count.visible = false
#	else:
#		$Count.text = String(itemQuantity)

# Used for updating the current item
func set_item(name : String, quantity : int):
	itemName = name
	itemQuantity = quantity
	$Texture.texture = Game.itemData[itemName]["Sprite"]
	var stackSize = int(Game.itemData[itemName]["StackSize"])
	
	update_text()
	if stackSize == 1:
		$Count.visible = false
	else:
		$Count.text = String(itemQuantity)
		$Count.visible = true

func update_text():
	$Count.text = String(itemQuantity)

func add_item_quantity(amountToAdd):
	itemQuantity += amountToAdd
	update_text()

func decrease_item_quantity(amountToRemove):
	itemQuantity -= amountToRemove
	update_text()
