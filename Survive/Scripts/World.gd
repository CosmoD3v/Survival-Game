extends Node2D

var playerScene = preload("res://Scenes/Player.tscn")
var treeScene = preload("res://Scenes/Tree.tscn")
var stoneScene = preload("res://Scenes/Stone.tscn")
var perlinNoise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

var grid : Dictionary # Array of disks
var gridChunks : Dictionary # Array of chunks
var previouslyLoadedChunks : Array # Previously loaded 9 chunks
var chunksObjects : Dictionary # Array of objects for each chunk
var currentChunk : Vector2 # Chunk the player is in (Center of 9 chunks)
const CHUNK_SIZE = Vector2(8, 8) # Chunk size in grid cells
const pointToChunkScale = CHUNK_SIZE * 200 / sqrt(2) # Pixels per chunk

func _ready() -> void:
	add_player()

func add_player():
	var player = playerScene.instance()
	$Players.add_child(player)
	player.init()

func get_chunks_to_prepare(originChunk : Vector2):
	var chunksToPrepare : Array = []
	for y in range(-1, 2):
		for x in range(-1, 2):
			chunksToPrepare.append(Vector2(x, y) + originChunk)
	return chunksToPrepare

func update_chunks(originPoint : Vector2):
	var originChunk : Vector2 = (originPoint / pointToChunkScale).floor()
	if currentChunk != originChunk:
		prepare_chunks(originChunk)

func prepare_chunks(originChunk : Vector2):
	currentChunk = originChunk
	var chunksToPrepare : Array = get_chunks_to_prepare(originChunk)
	for chunk in chunksToPrepare:
		# generate chunks
		var chunkAlreadyGenerated : bool = gridChunks.has(str(chunk.x) + " " + str(chunk.y))
		if !chunkAlreadyGenerated:
			gen_chunk(chunk)
		if !previouslyLoadedChunks.has(chunk):
			chunksObjects[str(chunk.x) + " " + str(chunk.y)] = []
			var cellPosStart = chunk * CHUNK_SIZE
			var cellPosEnd = cellPosStart + CHUNK_SIZE
			for x in range(cellPosStart.x, cellPosEnd.x):
				for y in range(cellPosStart.y, cellPosEnd.y):
					if grid.has(str(x) + " " + str(y)):
						var vec = grid[str(x) + " " + str(y)]
						if perlinNoise.get_noise_2d(vec.x, vec.y) > -.1 && perlinNoise.get_noise_2d(vec.x, vec.y) < .1:
							var tree = treeScene.instance()
							$Objects.add_child(tree)
							tree.position = vec
							chunksObjects[str(chunk.x) + " " + str(chunk.y)].append(tree)
	for chunk in previouslyLoadedChunks:
		if !chunksToPrepare.has(chunk):
			for tree in chunksObjects[str(chunk.x) + " " + str(chunk.y)]:
				tree.queue_free()
			# warning-ignore:return_value_discarded
			chunksObjects.erase(str(chunk.x) + " " + str(chunk.y))
	previouslyLoadedChunks = chunksToPrepare
#	print($Objects.get_child_count())

func gen_chunk(chunk : Vector2):
	gridChunks[str(chunk.x) + " " + str(chunk.y)] = chunk
	
	var r = 200
	var k = 5
	var w = r / sqrt(2)
	var active = []
	
	var gridPosStart = chunk * CHUNK_SIZE
	var gridPosEnd = gridPosStart + CHUNK_SIZE
	
	var posStart = gridPosStart * w
	var posEnd = gridPosEnd * w
	
	var gridMidPosStart = (CHUNK_SIZE / 2).floor() + CHUNK_SIZE * chunk
	var gridMidPosEnd = gridMidPosStart + Vector2.ONE
	
	rng.randomize()
	var x = rng.randi_range(gridMidPosStart.x * w, gridMidPosEnd.x * w)
	var y = rng.randi_range(gridMidPosStart.y * w, gridMidPosEnd.y * w)
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
			var sample = Vector2(sampleX, sampleY) * rand_range(r, r * 2)
			sample += p
			sample = sample.floor()
			
			if sample.x < posStart.x or sample.y < posStart.y or sample.x > posEnd.x or sample.y > posEnd.y:
				continue
			
			var col = floor(sample.x / w)
			var row = floor(sample.y / w)
			
			var ok = true
			for i in range(-1, 2):
				for j in range(-1, 2):
					if grid.has(str(col + i) + " " + str(row + j)):
						var neighbor = grid[str(col + i) + " " + str(row + j)]
						if sample.distance_squared_to(neighbor) < r * r:
							ok = false
			if ok:
				grid[str(col) + " " + str(row)] = sample
				active.append(sample)
				found = true
		if !found:
			active.remove(pIndex)
