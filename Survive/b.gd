extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var noise = OpenSimplexNoise.new()
	var texture = NoiseTexture.new()
	noise.period = 1000
	texture.noise = noise
	texture.width = 1000
	texture.height = 1000
	self.texture = texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(1, 0)
	texture.noise_offset = position
	pass
