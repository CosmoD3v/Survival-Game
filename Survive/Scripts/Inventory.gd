extends Control

const SlotClass = preload("res://Scripts/Slot.gd")
const ItemClass = preload("res://Scripts/Item.gd")
const NUM_INVENTORY_SLOTS = 9

onready var inventorySlots = $SlotGrid
onready var player = find_parent("Player")
onready var slotOffset = ($SlotGrid/Slot1.get_combined_minimum_size() / 2) - Vector2(8, 8)

var inventory : Dictionary
var itemQuery : Dictionary
var hotbarSelected : int
var mouseItem = null

signal item_quantity_changed
signal is_craftable

# Initialize hotbar and inventory
func init() -> void:
	
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slotIndex = i
	
	var saveData : Dictionary = Game.load_user_data()
	for index in saveData:
		inventory_changed(index, saveData[index]["ItemQuantity"], saveData[index]["ItemName"])
	
	update_hotbar()
	player.set_hand_item()

#func get_items_and_quantities() -> Dictionary:
#	var itemsAndQuantities : Dictionary = {}
#	for i in inventory:
#		var itemName = inventory[i]["ItemName"]
#		if (itemsAndQuantities.has(itemName)):
#			continue
#		itemsAndQuantities[itemName] = get_quantity_of_item(itemName)
#	return itemsAndQuantities
#
#func get_quantity_of_item(itemName : String) -> int:
#	var quantity = 0
#	for i in inventory:
#			if inventory[i]["ItemName"] == itemName:
#				quantity += inventory[i]["ItemQuantity"]
#	return quantity

func is_craftable(item : Dictionary):
	var itemName : String = item["ItemName"]
	var itemRecipy : Dictionary = item["Recipy"]
	for material in itemRecipy:
		if (!itemQuery.has(material) || itemQuery[material]["Total"] < itemRecipy[material]):
#			print(itemName + " is not craftable")
			emit_signal("is_craftable", itemName, false)
			return
	emit_signal("is_craftable", itemName, true)
#	print(itemName + " is craftable")

# Needs implemented
func remove_items(_itemsAndQuantities : Dictionary):
	pass

# Call when an item needs to be collected by the player
# Needs refactored for itemQuantities greater than StackSize of that item
func add_item(itemName, itemQuantity):
	if (Game.itemData[itemName]["StackSize"] > 1):
		for item in inventory:
			if inventory[item]["ItemName"] == itemName:
				var stackSize = int(Game.itemData[itemName]["StackSize"])
				var ableToAdd = stackSize - inventory[item]["ItemQuantity"]
				if (ableToAdd == 0):
					continue
				if itemQuantity <= ableToAdd:
					inventory_changed(item, itemQuantity)
#					print(inventory)
					return
				else:
					inventory_changed(item, ableToAdd)
					itemQuantity -= ableToAdd
	# Item doesn't exist in inventory yet, so add it to an empty slot
	for index in range(NUM_INVENTORY_SLOTS):
		if inventory.has(index) == false:
			inventory_changed(index, itemQuantity, itemName)
			itemQuantity = 0
			break
	# Implement items dropping on ground when inventory can't fit this item
	if (itemQuantity > 0):
		pass

# This function must be used to properly update inventory, itemQuery, GUI, and emit a signal for these changes
# There are 3 total cases:
#
# 1 - If only an index is provided, the inventory item at that index is removed
# 2 - If index and itemQuanitty are provided, the inventory item at that index has it's quantity changed
# 3 - If all 3 args are provided, a new item is created in the inventory at that index
# 
func inventory_changed(index : int, itemQuantity : int = 0, itemName : String = ""):
	# Case 1
	if (itemQuantity == 0):
		
		itemName = inventory[index]["ItemName"]
		# warning-ignore:return_value_discarded
		inventory.erase(index)
		
		# Erase this index from this item and then if the item dict is empty, erase it from the itemQuery
		itemQuery[itemName].erase(index)
		calc_new_item_total_in_query(itemName)
		if (itemQuery[itemName]["Total"] == 0):
			# warning-ignore:return_value_discarded
			itemQuery.erase(itemName)
		
	# Case 2
	elif (itemName.empty()):
#		print("CASE 2")
		if (inventory.has(index)):
			itemName = inventory[index]["ItemName"]
		else:
			itemName = mouseItem.slot.itemName
		inventory[index]["ItemQuantity"] += itemQuantity
		
		#
		itemQuery[itemName][index] += itemQuantity
		calc_new_item_total_in_query(itemName)
		
	# Case 3
	else: # If an itemName is specified, we are creating a new item at this index
#		print("CASE 3")
		if (inventory.has(index) && !inventory[index].empty()):
			var oldItemName = inventory[index]["ItemName"]
			itemQuery[oldItemName].erase(index)
			calc_new_item_total_in_query(oldItemName)
			if (itemQuery[oldItemName]["Total"] == 0):
				# warning-ignore:return_value_discarded
				itemQuery.erase(oldItemName)
			var oldItemTotal : int = 0 if !itemQuery.has(oldItemName) else itemQuery[oldItemName]["Total"]
			emit_signal("item_quantity_changed", oldItemName)
		inventory[index] = {
			"ItemName" : itemName,
			"ItemQuantity" : itemQuantity
		}
		if (!itemQuery.has(itemName)):
			itemQuery[itemName] = {}
		itemQuery[itemName][index] = itemQuantity
		calc_new_item_total_in_query(itemName)
		
	update_slot_gui(index)
#	print(itemQuery)
	var itemTotal : int = 0 if !itemQuery.has(itemName) else itemQuery[itemName]["Total"]
	emit_signal("item_quantity_changed", itemName)

func update_slot_gui(index : int):
	var slot : SlotClass = inventorySlots.get_child(index)
	if (inventory.has(index)):
		slot.set_item(inventory[index]["ItemName"], inventory[index]["ItemQuantity"])
	else:
		slot.remove_item()

func calc_new_item_total_in_query(itemName : String):
	var total : int = 0
	if (itemQuery.has(itemName)):
		for i in itemQuery[itemName]:
			var keyAtIndex = i
			var countAtIndex = itemQuery[itemName][i]
			if (typeof(keyAtIndex) == TYPE_INT):
				total += countAtIndex
	itemQuery[itemName]["Total"] = total





# Called when user clicks on the inventory
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.is_pressed():
			if mouseItem:
				if slot.item:
					swap_stack_items(slot)
				else:
					mouse_to_slot(slot)
			else:
				if slot.item:
					slot_to_mouse(slot)
			player.set_hand_item()

func swap_stack_items(slot : SlotClass):
	if mouseItem.itemName == slot.item.itemName:
		var stackSize = int(Game.itemData[slot.item.itemName]["StackSize"])
		var ableToAdd = stackSize - slot.item.itemQuantity
		if ableToAdd > 0:
			if mouseItem.itemQuantity <= ableToAdd:
				inventory_changed(slot.slotIndex, mouseItem.itemQuantity)
				mouseItem.queue_free()
				mouseItem = null
			else:
				inventory_changed(slot.slotIndex, ableToAdd)
				mouseItem.decrease_item_quantity(ableToAdd)
	else:
		var itemQuantity = mouseItem.itemQuantity
		var itemName = mouseItem.itemName
		mouseItem.queue_free()
		var item = slot.ItemClass.instance()
		item.set_item(slot.item.itemName, slot.item.itemQuantity)
		mouseItem = item
		add_child(item)
		inventory_changed(slot.slotIndex, itemQuantity, itemName)
		update_mouse_item_position()

func slot_to_mouse(slot : SlotClass):
	var item = slot.ItemClass.instance()
	item.set_item(slot.item.itemName, slot.item.itemQuantity)
	mouseItem = item
	add_child(item)
	inventory_changed(slot.slotIndex)
	update_mouse_item_position()

func mouse_to_slot(slot : SlotClass):
	inventory_changed(slot.slotIndex, mouseItem.itemQuantity, mouseItem.itemName)
	mouseItem.queue_free()
	mouseItem = null

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
