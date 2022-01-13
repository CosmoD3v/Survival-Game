extends Panel

var ItemClass = preload("res://Scenes/Item.tscn")
var item = null
var slotIndex

func _ready() -> void:
	pass

# Instances the slot and provides the item_name & item_quanitity from the inventory
# to create the item visual for this slot
func init():
	if Game.inventory.has(slotIndex):
		item = ItemClass.instance()
		add_child(item)
		item.init(Game.inventory[slotIndex][0],
			Game.inventory[slotIndex][1])
		item.position = Vector2(8, 8)

# Used for updating the item stored in this slot
func update_item(itemName, itemQuantity):
	if !item:
		item = ItemClass.instance()
		add_child(item)
		item.init(itemName, itemQuantity)
		item.position = Vector2(8, 8)
	else:
		item.set_item(itemName, itemQuantity)

# Used by inventory to update this slot after something is taken from it
func pick_from_slot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null

# Used by inventory to update this slot after something is put into it
func put_into_slot(newItem):
	item = newItem
	item.position = Vector2(8, 8)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
