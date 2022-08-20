extends Node2D

var playerScene = preload("res://Scenes/Player.tscn")
var treeScene = preload("res://Scenes/Tree.tscn")
var stoneScene = preload("res://Scenes/Stone.tscn")
var diskNoise = OpenSimplexNoise.new()
var heightNoise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

var grid : Dictionary # List of generated disks
var alreadyGenChunks : Dictionary # List of generated chunks
var chunks : Dictionary
var currentChunk : Vector2 = Vector2(9999, 9999) # Chunk the player is in; 9999 prevents issues loading first chunk

var previouslyLoadedChunks : Array # Previously loaded chunks
var chunksToLoad : Array
var chunksToUnload : Array

const CELLS_PER_CHUNK = Vector2(3, 3) # Chunk size in grid cells
const DISK_RADIUS = 140 * sqrt(2) # Radius in pixels
const CELL_SIZE = DISK_RADIUS / sqrt(2) # Cell width & height in pixels
const PIXELS_PER_CHUNK = CELLS_PER_CHUNK * DISK_RADIUS / sqrt(2) # Pixels per chunk

func _ready() -> void:
	#diskNoise.period = 500
	heightNoise.seed = 1
	heightNoise.period = 2000
	add_player()

func add_player():
	var player = playerScene.instance()
	$Players.add_child(player)
	player.init()

func _physics_process(_delta: float) -> void:
	unload_load_chunks()

func unload_load_chunks():
	for _i in range(3):
		if !chunksToUnload.empty():
			var chunk = chunksToUnload.pop_front()
			unload_chunk(chunk)
		if !chunksToLoad.empty():
			var chunk = chunksToLoad.pop_front()
			var chunkAlreadyGenerated : bool = alreadyGenChunks.has(str(chunk.x) + " " + str(chunk.y))
			if !chunkAlreadyGenerated:
				gen_chunk(chunk)
			load_chunk(chunk)

func get_chunks_to_prepare(originChunk : Vector2):
	var chunksToPrepare : Array = []
	for y in range(-3, 4):
		for x in range(-3, 4):
			chunksToPrepare.append(Vector2(x, y) + originChunk)
	return chunksToPrepare

func update_chunks(originPoint : Vector2):
	var originChunk : Vector2 = (originPoint / PIXELS_PER_CHUNK).floor()
	if currentChunk != originChunk:
		currentChunk = originChunk
		prepare_chunks(currentChunk)

func prepare_chunks(originChunk : Vector2):
	var chunksToPrepare : Array = get_chunks_to_prepare(originChunk)
	
	#unload_load_area(chunksToPrepare)
	
	for chunk in chunksToPrepare:
		if !previouslyLoadedChunks.has(chunk):
			chunksToLoad.append(chunk)
	for chunk in previouslyLoadedChunks:
		if !chunksToPrepare.has(chunk):
			chunksToUnload.append(chunk)
	previouslyLoadedChunks = chunksToPrepare

func gen_chunk(chunk : Vector2):
	alreadyGenChunks[str(chunk.x) + " " + str(chunk.y)] = []
	gen_disks(chunk)

func load_chunk(chunk : Vector2):
	# Register chunk in list and add it to the scene
	var chunkID : String = str(chunk.x) + " " + str(chunk.y)
	var chunkNode = Node2D.new()
	chunkNode.set_name(chunkID)
	chunks[chunkID] = chunkNode
	$Chunks.add_child(chunkNode)
	
	# Loop over each cell in the chunk
	var cellPosStart = chunk * CELLS_PER_CHUNK
	var cellPosEnd = cellPosStart + CELLS_PER_CHUNK
	for x in range(cellPosStart.x, cellPosEnd.x):
		for y in range(cellPosStart.y, cellPosEnd.y):
			var cellID : String = str(x) + " " + str(y)
			if grid.has(cellID):
				var worldPos = grid[cellID]
				gen_objects(worldPos, chunkNode)

func gen_objects(worldPos : Vector2, chunkNode : Node2D):
	if (heightNoise.get_noise_2d(worldPos.x, worldPos.y)) > .15:
		var tree = treeScene.instance()
		tree.position = worldPos
		chunkNode.add_child(tree)

#func make_bg(arr : Array):
#	#var worldPos : Vector2 = arr[0]
#	var x : int = arr[0]
#	var y : int = arr[1]
#	var chunkNode : Node2D = arr[2]
#	var noise = arr[4]
#	var noise = OpenSimplexNoise.new()
#	var sprite : Sprite = Sprite.new()
#	var img = noise.get_image(CELL_SIZE, CELL_SIZE, Vector2(x, y) * CELL_SIZE)
#	var tex = ImageTexture.new()
#	tex.create_from_image(img)
#	sprite.texture = tex
#	sprite.z_index = -1
#	sprite.position = Vector2(x, y) * CELL_SIZE
#	var t = Timer.new()
#	t.set_wait_time(3)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	call_deferred("bg_complete", arr[3])
#	pass

#func bg_complete(_thread : Thread):
#	chunkNode.add_child(sprite)
#	objToLoad.push_back([chunkNode, sprite])
#	chunkNode.add_child(sprite)
#	if(!_thread.is_alive()):
#	_thread.wait_to_finish()
#	pass

func unload_chunk(chunk : Vector2):
	var chunkID : String = str(chunk.x) + " " + str(chunk.y)
	if chunks.has(chunkID):
		var chunkNode : Node2D = chunks[chunkID]
		for object in chunkNode.get_children():
			object.queue_free()
		$Chunks.remove_child(chunkNode)
		chunkNode.queue_free()
		var _success = chunks.erase(chunkID)
	else:
		chunksToUnload.push_back(chunk)

func gen_disks(chunk : Vector2):
	var k = 5
	var active = []
	
	var gridPosStart = chunk * CELLS_PER_CHUNK
	var gridPosEnd = gridPosStart + CELLS_PER_CHUNK
	
	var posStart = gridPosStart * CELL_SIZE
	var posEnd = gridPosEnd * CELL_SIZE
	
	var gridMidPosStart = (CELLS_PER_CHUNK / 2).floor() + CELLS_PER_CHUNK * chunk
	var gridMidPosEnd = gridMidPosStart + Vector2.ONE
	
	rng.randomize()
	var x = rng.randi_range(gridMidPosStart.x * CELL_SIZE, gridMidPosEnd.x * CELL_SIZE)
	var y = rng.randi_range(gridMidPosStart.y * CELL_SIZE, gridMidPosEnd.y * CELL_SIZE)
	var pos = Vector2(x, y)
	
	grid[str(gridMidPosStart.x) + " " + str(gridMidPosStart.y)] = pos
	active.append(pos)
	
	# Step 2
	while !active.empty():
		var pIndex = rng.randi_range(0, active.size() - 1)
		var p = active[pIndex]
		var found = false
		for _n in range(k):
			var a = rng.randf_range(0, PI * 2)
			var sampleX = cos(a)
			var sampleY = sin(a)
			var sample = Vector2(sampleX, sampleY) * rand_range(DISK_RADIUS, DISK_RADIUS * 2)
			sample += p
			sample = sample.floor()
			
			if sample.x < posStart.x or sample.y < posStart.y or sample.x > posEnd.x or sample.y > posEnd.y:
				continue
			
			var col = floor(sample.x / CELL_SIZE)
			var row = floor(sample.y / CELL_SIZE)
			
			var ok = true
			for i in range(-1, 2):
				for j in range(-1, 2):
					if grid.has(str(col + i) + " " + str(row + j)):
						var neighbor = grid[str(col + i) + " " + str(row + j)]
						if sample.distance_squared_to(neighbor) < DISK_RADIUS * DISK_RADIUS:
							ok = false
			if ok:
				grid[str(col) + " " + str(row)] = sample
				active.append(sample)
				found = true
		if !found:
			active.remove(pIndex)
