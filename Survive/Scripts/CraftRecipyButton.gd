extends TextureButton

var isCraftable : bool

signal craft_recipy

func _ready() -> void:
	var _e = connect("pressed", self, "pressed")
	pass

func pressed():
	if (isCraftable):
		emit_signal("craft_recipy", name)
