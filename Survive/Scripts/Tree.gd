extends StaticBody2D

var resourceCap = 5
var currentResource = resourceCap
var hit = false
const KNOCKBACK_STRENGTH = 15
onready var tween = $SpriteTween
onready var sprite = $Sprite

func _ready() -> void:
	set_meta('type', 'resource')

# Called by player when this object is harvested
func collect_resource(player, inventory):
	knockback(player)
	if !Game.inventory.has(Game.hotbarSelected):
		return
	elif Game.inventory[Game.hotbarSelected][0] == "Axe":
		inventory.add_item("Wood", 1)

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
