extends StaticBody2D

onready var tween = $SpriteTween
onready var sprite = $Sprite
const KNOCKBACK_STRENGTH = 15
var resourceCap = 5
var currentResource = resourceCap
var hit = false

func _ready() -> void:
	$InteractArea.set_meta("Type", "Resource")
	addMeta()

func addMeta():
	pass

func harvest(_harvestTool : String):
	pass

# Called by player when this object is harvested
func collect_resource(playerNode : Node, harvestTool : String):
	knockback(playerNode)
	return harvest(harvestTool)

# Start animation for when the player hits the object
func knockback(player):
	var delta = KNOCKBACK_STRENGTH * (position - player.position).normalized()
	tween.interpolate_property(sprite, "offset", Vector2.ZERO, delta, .05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	hit = true

# End animation for when the player hits the object
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_SpriteTween_tween_completed(object: Object, key: NodePath) -> void:
	if hit:
		tween.interpolate_property(sprite, "offset", sprite.offset, Vector2.ZERO, .05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		hit = false
