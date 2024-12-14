# Asteroids Node Code
extends Node2D

@export var chunk_size = 512 # Definiert die Größe der Chunks
@export var view_distance = 3 # Angepasst für Fullscreen (größerer Sichtbereich)

var active_chunks = {} # Gespeicherte aktive Chunks
var asteroid_scene = preload("res://Stages/World/Asteroids/asteroid.tscn")
var player_node = null # Referenz auf den Spieler

func _ready():
	# Spieler-Node initialisieren
	player_node = get_parent().get_parent().get_node("Ship")

func _process(delta):
	_update_chunks()

func _update_chunks():
	if player_node == null:
		return # Sicherstellen, dass der Spieler existiert

	var player_position = player_node.global_position
	var current_chunk = Vector2(floor(player_position.x / chunk_size), floor(player_position.y / chunk_size))

	# Speichere vorhandene Chunks
	for x in range(current_chunk.x - view_distance, current_chunk.x + view_distance + 1):
		for y in range(current_chunk.y - view_distance, current_chunk.y + view_distance + 1):
			var chunk_key = Vector2(x, y)
			if not active_chunks.has(chunk_key):
				_load_chunk(chunk_key)

	# Behalte alle Chunks in Reichweite
	var chunks_to_keep = {}
	for chunk_key in active_chunks.keys():
		if chunk_key.distance_to(current_chunk) <= view_distance:
			chunks_to_keep[chunk_key] = active_chunks[chunk_key]
		else:
			_unload_chunk(chunk_key)

	active_chunks = chunks_to_keep

	# Deaktiviere entfernte Chunks
	for chunk_key in active_chunks.keys():
		if not chunks_to_keep.has(chunk_key):
			_unload_chunk(chunk_key)

func _load_chunk(chunk_key):
	var chunk_position = chunk_key * chunk_size

	# Falls der Chunk bereits existiert, nichts tun
	if active_chunks.has(chunk_key):
		for asteroid in active_chunks[chunk_key]:
			asteroid.visible = true
		return

	active_chunks[chunk_key] = []

	# Spawn einzelner oder clusterweise Asteroiden
	for i in range(randi_range(5, 10)): # Mehr Asteroiden für größere Sichtweite
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = chunk_position + Vector2(randi_range(0, chunk_size), randi_range(0, chunk_size))
		add_child(asteroid)
		active_chunks[chunk_key].append(asteroid)

func _unload_chunk(chunk_key):
	# Verstecke Chunks, anstatt sie zu löschen
	if active_chunks.has(chunk_key):
		for asteroid in active_chunks[chunk_key]:
			if asteroid and is_instance_valid(asteroid):
				asteroid.visible = false
