extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERATION = 5000
var motion = Vector2()
const SWING_TIME = .5
const SWING_MIN = 90
const SWING_MAX = 45
onready var swing_timer = $ItemArea/SwingTimer
onready var tween = $ItemArea/SwingAnimation
onready var inventoryNode = $PlayerUI/UIContainer/InventoryContainer/Inventory
var worldNode : Node
var allowAction = true

func init():
	worldNode = get_parent().get_parent()
	worldNode.prepare_chunks(position)
	inventoryNode.init()

# Rotate player sprite to face mouse and check for input
func _process(_delta: float) -> void:
	worldNode.update_chunks(position)
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("ui_use_hand") && allowAction:
		swing_hand()
	if Input.is_action_just_pressed("ui_plus") && $Camera.zoom < Vector2(5, 5):
		$Camera.zoom += Vector2.ONE
	if Input.is_action_just_pressed("ui_minus") && $Camera.zoom > Vector2(1, 1):
		$Camera.zoom -= Vector2.ONE

func _physics_process(delta: float) -> void:
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)

# Used by physics_process
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

# Used by physics_process
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

# Used by physics_process
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

# Updates the sprite based on hotbar
func set_hand_item():
	if inventoryNode.inventory.has(inventoryNode.hotbarSelected):
		var itemName = inventoryNode.inventory[inventoryNode.hotbarSelected]["ItemName"]
		var itemCategory = Game.itemData[itemName]["ItemCategory"]
		if itemCategory == "Tool":
			$ItemArea/ItemSprite.texture = Game.itemData[itemName]["Sprite"]
			return
	$ItemArea/ItemSprite.texture = null
	tween.remove($ItemArea, "rotation_degrees")
	$ItemArea.rotation_degrees = SWING_MIN

# Start function of swing
func swing_hand():
	if !swing_timer.time_left:
		swing_timer.start(SWING_TIME)
		tween.interpolate_property($ItemArea, "rotation_degrees", SWING_MIN, SWING_MAX, SWING_TIME / 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

# End function of swing
func swing_hand_back():
	if $ItemArea.rotation_degrees == SWING_MAX:
		tween.interpolate_property($ItemArea, "rotation_degrees", SWING_MAX, SWING_MIN, SWING_TIME / 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		for area in $ItemArea.get_overlapping_areas():
			if area.has_meta("Type"):
				var resource = area.get_meta("Type")
				var areaNode = area.get_parent()
				match resource:
					"Resource":
						areaNode.collect_resource(self, inventoryNode)
					_:
						print("not a resource")

func _on_SwingAnimation_tween_completed(_object: Object, _key: NodePath) -> void:
	swing_hand_back()
