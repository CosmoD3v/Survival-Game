extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERATION = 5000
var motion = Vector2()
const SWING_TIME = .5
const SWING_MIN = 90
const SWING_MAX = 45
onready var swing_timer = $Sprite/ItemArea/SwingTimer
onready var tween = $Sprite/ItemArea/SwingAnimation
onready var inventory = $PlayerUI/Inventory
var allowAction = true

func _ready() -> void:
	pass

# Rotate player sprite to face mouse and check for input
func _process(_delta: float) -> void:
	$Sprite.look_at(get_global_mouse_position())
	if Input.is_action_pressed("ui_use_hand") && allowAction:
		swing_hand()

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
	if Game.inventory.has(Game.hotbarSelected):
		var itemCategory = Game.itemData.get(Game.inventory[Game.hotbarSelected][0]).get("ItemCategory")
		if itemCategory == "Tool":
			$Sprite/ItemArea/ItemSprite.texture = load("res://Sprites/" + Game.inventory[Game.hotbarSelected][0] + ".png")
			return
	$Sprite/ItemArea/ItemSprite.texture = null
	tween.remove($Sprite/ItemArea, "rotation_degrees")
	$Sprite/ItemArea.rotation_degrees = SWING_MIN

# Start function of swing
func swing_hand():
	if !swing_timer.time_left:
		swing_timer.start(SWING_TIME)
		tween.interpolate_property($Sprite/ItemArea, "rotation_degrees", SWING_MIN, SWING_MAX, SWING_TIME / 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

# End function of swing
func swing_hand_back():
	if $Sprite/ItemArea.rotation_degrees == SWING_MAX:
		tween.interpolate_property($Sprite/ItemArea, "rotation_degrees", SWING_MAX, SWING_MIN, SWING_TIME / 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		for area in $Sprite/ItemArea.get_overlapping_areas():
			var object = area.get_parent()
			if object.has_meta("type"):
				var resource = object.get_meta("type")
				match resource:
					"resource":
						object.collect_resource(self, inventory)
					_:
						print("not a resource")

func _on_SwingAnimation_tween_completed(_object: Object, _key: NodePath) -> void:
	swing_hand_back()
