extends Panel

var ItemClass = preload("res://Scenes/Item.tscn")
var inventoryNode : Node
var item: Node
var slotIndex: int

func _ready() -> void:
	inventoryNode = find_parent("Inventory")

func set_item(itemName : String, itemQuantity : int):
	if !item:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(itemName, itemQuantity)
		item.position = Vector2(8, 8)
	else:
		item.set_item(itemName, itemQuantity)

func remove_item():
	remove_child(item)
	item.queue_free()
	item = null
