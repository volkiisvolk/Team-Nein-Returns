# Asteroids Node Code
extends Node2D

@export var chunk_size = 1024 # Definiert die Größe der Chunks
@export var view_distance = 5 # Angepasst für Fullscreen (größerer Sichtbereich)

var active_chunks = {} # Gespeicherte aktive Chunks
var asteroid_scene = preload("res://Entities/Asteroids/asteroid.tscn")
var player_node = null # Referenz auf den Spieler
var last_chunk = null
var asteroid_pool = []

# Mögliche Eigenschaften für Asteroiden
var sizes = ["small", "medium", "large"]
var colors = ["red", "blue", "green"]
# Lebenspunkte basierend auf der Größe
var size_speed_mapping: Dictionary = {
	"small": 50,
	"medium": 40,
	"large": 10
}
var size_health_mapping: Dictionary = {
	"small": 50,
	"medium": 100,
	"large": 200
}

func _ready():
	# Spieler-Node initialisieren
	player_node = get_parent().get_parent().get_node("Ship")
	_init_pool(50)  # Initialisiere den Pool mit 50 Asteroiden

func _process(delta):
	if player_node == null:
		return

	var player_position = player_node.global_position
	var current_chunk = Vector2(floor(player_position.x / chunk_size), floor(player_position.y / chunk_size))

	if last_chunk != current_chunk:
		_update_chunks(current_chunk)
		last_chunk = current_chunk

func _update_chunks(current_chunk):
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
	# Falls der Chunk bereits existiert, nur sichtbar machen
	if active_chunks.has(chunk_key):
		for asteroid in active_chunks[chunk_key]:
			if asteroid and is_instance_valid(asteroid):
				asteroid.visible = true
		return
	active_chunks[chunk_key] = []
	# Spawn einzelner oder clusterweise Asteroiden
	for i in range(randi_range(5, 10)):
		var asteroid = _get_asteroid()
		asteroid.position = chunk_position + Vector2(randi_range(0, chunk_size), randi_range(0, chunk_size))
		asteroid.visible = true
		active_chunks[chunk_key].append(asteroid)

func _unload_chunk(chunk_key):
	# Verstecke Chunks, anstatt sie zu löschen
	if active_chunks.has(chunk_key):
		for asteroid in active_chunks[chunk_key]:
			if asteroid and is_instance_valid(asteroid):
				asteroid.visible = false

func _init_pool(size):
	for i in range(size):
		var asteroid = asteroid_scene.instantiate()
		asteroid.visible = false
		asteroid_pool.append(asteroid)
		add_child(asteroid)

func _get_asteroid():
	for asteroid in asteroid_pool:
		if not asteroid.visible:
			return asteroid
	var new_asteroid = asteroid_scene.instantiate()
	var random_size = sizes[randi() % sizes.size()]
	var random_color = colors[randi() % colors.size()]
	
	new_asteroid.size = random_size
	new_asteroid.color = random_color
	new_asteroid.health = size_health_mapping[random_size]
	new_asteroid.speed = size_speed_mapping[random_size]
		
	asteroid_pool.append(new_asteroid)
	add_child(new_asteroid)
	return new_asteroid
