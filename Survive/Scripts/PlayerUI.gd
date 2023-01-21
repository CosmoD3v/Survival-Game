extends CanvasLayer

onready var craftMenu = $CraftMenu
onready var inventory = $UIContainer/InventoryContainer/Inventory

func _ready() -> void:
	craftMenu.connect("item_created", inventory, "add_item")
	craftMenu.connect("request_craftable", inventory, "is_craftable")
	inventory.connect("item_quantity_changed", craftMenu, "refresh")
	inventory.connect("is_craftable", craftMenu, "set_recipy_craft_state")
