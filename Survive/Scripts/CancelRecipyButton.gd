extends TextureButton

var tween : Tween = Tween.new()
var item : String

func _ready() -> void:
# warning-ignore:return_value_discarded
	tween.start()

# warning-ignore:shadowed_variable
func init(craftMenu : Node, recipy : String, craftTime : int):
	var _e = connect("pressed", craftMenu, "remove_from_queue", [self])
	item = recipy
	self.add_child(tween)
# warning-ignore:return_value_discarded
	tween.interpolate_property(material, "shader_param/percentage", 0, 1, craftTime, Tween.TRANS_LINEAR, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.connect("tween_completed", craftMenu, "finish_crafting_recipy", [self])
