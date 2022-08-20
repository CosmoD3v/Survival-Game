extends Control

const slotClass = preload("res://Scripts/Slot.gd")
const itemClass = preload("res://Scripts/Item.gd")
const NUM_INVENTORY_SLOTS = 9
onready var inventorySlots = $SlotGrid
onready var player = find_parent("Player")
onready var slotOffset = ($SlotGrid/Slot1.get_combined_minimum_size() / 2) - Vector2(8, 8)
var inventory: Dictionary
var hotbarSelected: int
var mouseItem = null

# Initialize hotbar and inventory
func init() -> void:
	inventory = Game.load_user_data()
	update_hotbar()
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slotIndex = i
		slots[i].init()

# Called by slot_gui_input to refresh the visual elements of each slot of the inventory
func update_inventory():
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		if inventory.has(i):
			slots[i].update_item(inventory[i]["ItemName"], inventory[i]["ItemQuantity"])

# Call when an item needs to be collected by the player
func add_item(itemName, itemQuantity):
	for item in inventory:
		if inventory[item]["ItemName"] == itemName:
			var stackSize = int(Game.itemData[itemName]["StackSize"])
			var ableToAdd = stackSize - inventory[item]["ItemQuantity"]
			if ableToAdd >= itemQuantity:
				inventory[item]["ItemQuantity"] += itemQuantity
				update_inventory()
				return
			else:
				inventory[item]["ItemQuantity"] += ableToAdd
				itemQuantity -= ableToAdd
	
	# Item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = {
				"ItemName" : itemName,
				"ItemQuantity" : itemQuantity
			}
			update_inventory()
			return

# Controls data within the Game Singleton
func add_item_to_empty_slot(item: itemClass, slot: slotClass):
	inventory[slot.slotIndex] = {
		"ItemName" : item.itemName,
		"ItemQuantity" : item.itemQuantity
	}

func remove_item(slot: slotClass):
# warning-ignore:return_value_discarded
	inventory.erase(slot.slotIndex)

func add_item_quantity(slot: slotClass, quantityToAdd: int):
	inventory[slot.slotIndex]["ItemQuantity"] += quantityToAdd

# Called when user clicks on the inventory
func slot_gui_input(event: InputEvent, slot: slotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if mouseItem:
				if slot.item:
					swap_stack_items(event, slot)
				else:
					put_item_in(slot)
			else:
				if slot.item:
					pull_item_out(slot)
			player.set_hand_item()

# warning-ignore:unused_argument
func swap_stack_items(event, slot):
	if mouseItem.itemName == slot.item.itemName:
		var stackSize = int(Game.itemData[slot.item.itemName]["StackSize"])
		var ableToAdd = stackSize - slot.item.itemQuantity
		if ableToAdd >= mouseItem.itemQuantity:
			add_item_quantity(slot, mouseItem.itemQuantity)
			slot.item.add_item_quantity(mouseItem.itemQuantity)
			mouseItem.queue_free()
			mouseItem = null
		else:
			add_item_quantity(slot, ableToAdd)
			slot.item.add_item_quantity(ableToAdd)
			mouseItem.decrease_item_quantity(ableToAdd)
	else:
		# Data moving
		remove_item(slot)
		add_item_to_empty_slot(mouseItem, slot)
		# Visual update
		var tempItem = slot.item
		slot.pick_from_slot()
		slot.put_into_slot(mouseItem)
		# Update mouseItem
		mouseItem = tempItem
		update_mouse_item_position()

func put_item_in(slot):
	add_item_to_empty_slot(mouseItem, slot)
	slot.put_into_slot(mouseItem)
	mouseItem = null

func pull_item_out(slot):
	remove_item(slot)
	mouseItem = slot.item
	slot.pick_from_slot()
	update_mouse_item_position()

# Used for updating which slot the user has selected
func update_hotbar(action = "0"):
	var slots = inventorySlots.get_children()
	slots[hotbarSelected].self_modulate = Color(1,1,1)
	match action:
		"+":
			if hotbarSelected < NUM_INVENTORY_SLOTS - 1:
				hotbarSelected += 1
			else:
				hotbarSelected = 0
		"-":
			if hotbarSelected > 0:
				hotbarSelected -= 1
			else:
				hotbarSelected = NUM_INVENTORY_SLOTS - 1
		_:
			hotbarSelected = int(action)
#	slots[hotbarSelected].self_modulate = Color(.9,.75,.27)
	slots[hotbarSelected].self_modulate = Color8(65, 65, 65)
	player.set_hand_item()

func update_mouse_item_position():
	mouseItem.global_position = get_global_mouse_position() - slotOffset

# Updates visual for hotbar and items held within the mouse
func _input(event):
	if mouseItem:
		update_mouse_item_position()
	if event is InputEventMouse:
		if event.is_action_pressed("ui_scroll_up"):
			update_hotbar("-")
		if event.is_action_pressed("ui_scroll_down"):
			update_hotbar("+")
	elif event is InputEventKey && event.is_pressed():
		match(event.scancode):
			KEY_1:
				update_hotbar(0)
			KEY_2:
				update_hotbar(1)
			KEY_3:
				update_hotbar(2)
			KEY_4:
				update_hotbar(3)
			KEY_5:
				update_hotbar(4)
			KEY_6:
				update_hotbar(5)
			KEY_7:
				update_hotbar(6)
			KEY_8:
				update_hotbar(7)
			KEY_9:
				update_hotbar(8)


func _on_SlotGrid_mouse_entered() -> void:
	player.allowAction = false

func _on_SlotGrid_mouse_exited() -> void:
	player.allowAction = true
