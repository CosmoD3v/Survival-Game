extends Panel

var ItemClass = preload("res://Scenes/Item.tscn")
var inventoryNode : Node
var item: Node
var slotIndex: int

func _ready() -> void:
	pass

# Instances the slot and provides the item_name & item_quanitity from the inventory
# to create the item visual for this slot
func init():
	inventoryNode = find_parent("Inventory")
	if inventoryNode.inventory.has(slotIndex):
		item = ItemClass.instance()
		add_child(item)
		item.init(inventoryNode.inventory[slotIndex]["ItemName"],
			inventoryNode.inventory[slotIndex]["ItemQuantity"])
		item.position = Vector2(8, 8)

# Used for updating the item stored in this slot
func update_item(itemName : String, itemQuantity : int):
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
	inventoryNode.add_child(item)
	item = null

# Used by inventory to update this slot after something is put into it
func put_into_slot(newItem : Node):
	item = newItem
	item.position = Vector2(8, 8)
	inventoryNode.remove_child(item)
	add_child(item)
