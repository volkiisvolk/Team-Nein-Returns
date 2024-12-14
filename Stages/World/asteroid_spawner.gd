extends Node2D

@export var chunk_size = 512 # Definiert die Größe der Chunks
@export var view_distance = 2 # Anzahl geladener Chunks um den Spieler herum

var active_chunks = {} # Gespeicherte aktive Chunks
var asteroid_scene = preload("res://Stages/World/Asteroids/asteroid.tscn")

func _process(delta):
	_update_chunks()

func _update_chunks():
	var player_position = get_parent().get_parent().get_node("Ship").global_position
	var current_chunk = Vector2(floor(player_position.x / chunk_size), floor(player_position.y / chunk_size))

	for x in range(current_chunk.x - view_distance, current_chunk.x + view_distance + 1):
		for y in range(current_chunk.y - view_distance, current_chunk.y + view_distance + 1):
			var chunk_key = Vector2(x, y)
			if not active_chunks.has(chunk_key):
				_load_chunk(chunk_key)

	for chunk_key in active_chunks.keys():
		if chunk_key.distance_to(current_chunk) > view_distance:
			_unload_chunk(chunk_key)

func _load_chunk(chunk_key):
	var chunk_position = chunk_key * chunk_size
	active_chunks[chunk_key] = []

	# Spawn einzelner oder clusterweise Asteroiden
	for i in range(randi_range(3, 8)):
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = chunk_position + Vector2(randi_range(0, chunk_size), randi_range(0, chunk_size))
		add_child(asteroid)
		active_chunks[chunk_key].append(asteroid)

func _unload_chunk(chunk_key):
	if active_chunks.has(chunk_key):
		for asteroid in active_chunks[chunk_key]:
			asteroid.queue_free()
		active_chunks.erase(chunk_key)
