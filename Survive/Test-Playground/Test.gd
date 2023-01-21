extends Node2D

var mid : PoolVector2Array
# Called when the node enters the scene tree for the first time.

func inventory_changed(index : int, quantity : int, itemName : String = ""):
	if (itemName.empty()):
		print("isempty")
	pass

func _ready() -> void:
	inventory_changed(0, 0)
	pass
#	var thread : Thread = Thread.new()
#	thread.start(self, "make_sprite", thread, Thread.PRIORITY_NORMAL)
	
#	var poly = Polygon2D.new()
#	var pool : Array
#	pool.append(Vector2(100,100))
#	pool.append(Vector2(100,200))
#	pool.append(Vector2(200,200))
#	pool.append(Vector2(200,100))
#
#
#	var n = pool.size()
#	pool.append(pool[0])
#
#	var apool : Array
#	for i in n:
#		apool.append(Vector2(pool[i] + pool[i + 1]) / 2)
#
#	var temp = pool.duplicate()
#	pool = apool.duplicate()
#	apool = temp
#	pool.append(pool[0])
#	apool.remove(apool.size() - 1)
#	var t = apool.pop_front()
#	apool.append(t)
#
#	var bpool : Array
#	for i in n:
#		bpool.append(_qb(pool[i], apool[i], pool[i + 1], .20))
#		bpool.append(_qb(pool[i], apool[i], pool[i + 1], .40))
#		bpool.append(_qb(pool[i], apool[i], pool[i + 1], .60))
#		bpool.append(_qb(pool[i], apool[i], pool[i + 1], .80))
#		pass
#	pool.remove(pool.size() - 1)
#	var shard : PoolVector2Array
#	while !pool.empty():
#		shard.append(pool.pop_front())
#		shard.append(bpool.pop_front())
#		shard.append(bpool.pop_front())
#		shard.append(bpool.pop_front())
#		shard.append(bpool.pop_front())
#
#	#(pool[2 * i] + pool[2 * i + 1]) / 2
##	for i in n:
##		pool.insert(2 * i + 1, (pool[2 * i] + pool[2 * i + 1]) / 2)
##	pool.remove(pool.size() - 1)
#	#pool.append(p)
#
#	poly.polygon = shard
#
#	self.add_child(poly)

func make_sprite(thread : Thread):
	var sprite : Sprite = Sprite.new()
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	var texture : NoiseTexture = NoiseTexture.new()
	texture.noise = noise
	texture.height = 5000
	texture.width = 5000
#	texture.noise_offset = Vector2(200, 500)
	sprite.texture = texture
	call_deferred("add_to_scene_tree", sprite, thread)

func add_to_scene_tree(object : Object, thread : Thread):
	add_child(object)
	thread.wait_to_finish()

func _qb(p0 : Vector2, a : Vector2, p1 : Vector2, t : float):
	var q0 = p0.linear_interpolate(a, t)
	var q1 = a.linear_interpolate(p1, t)
	var p = q0.linear_interpolate(q1, t)
	return p

#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var points : PoolVector2Array
#	for n in 200:
#		points.append(Vector2(rng.randi_range(0,600),rng.randi_range(0,600)))
#	var delaunay = Geometry.triangulate_delaunay_2d(points)
#
#	for index in len(delaunay) / 3:
#		var shard_pool = PoolVector2Array()
#		for n in range(3):
#			shard_pool.append(points[delaunay[(index * 3) + n]])
#
#		var shard = Polygon2D.new()
#		shard.polygon = shard_pool
#
#		shard.color = Color(rng.randf(),rng.randf(), rng.randf(), 0.2)
#		add_child(shard)
#
#		var m = (points[delaunay[(index * 3)]] + points[delaunay[(index * 3) + 1]] + points[delaunay[(index * 3) + 2]]) / 3
#
#		mid.append(m)
	
#	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
#	noise.period = 50
#	var img = noise.get_image(3, 3, Vector2(0, 0))
#	#print(img.data)
#
#	var n = 1000
#	var array = PoolByteArray()
#	for x in range(n):
#		for y in range(n):
#			array.push_back((1 + noise.get_noise_2d(x,y)) / 2 * 255)
#	var i : Image = Image.new()
#	i.create_from_data(n, n, false, Image.FORMAT_L8, array)
#
#	var imgtex = ImageTexture.new()
#	imgtex.create_from_image(i)
#	$Sprite.texture = imgtex
	
	
	pass # Replace with function body.
	
func _draw() -> void:
#	for m in mid:
#		draw_circle(m, 2, Color.black)
	pass
