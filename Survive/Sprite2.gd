extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _process(delta: float) -> void:
	pass
	position += Vector2(1, 0)
	texture.noise_offset = position
	#material.set_shader_param("offset", position/390)
	
	#print(material.get_method_list())
