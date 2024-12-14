extends Node2D

@export var speed = 50.0
@export var size: String = "medium"  # Größe des Asteroiden
@export var color: String = "purple"  # Farbe des Asteroiden
@export var health: int = 100  # Lebenspunkte des Asteroiden
var direction = Vector2.ZERO

var sprite_size: Dictionary = {
	"small": 0.4,
	"medium": 1,
	"large": 1.6
}

var image_data: Dictionary = {
	"small": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png")
	},
	"medium": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png")
	},
	"large": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png")
	}
}

@export var drop_scene: PackedScene

func _ready():
	# Initialisiere Lebenspunkte basierend auf der Größe
	
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	adjust_stats()
	
func adjust_stats():
	$Sprite2D.texture = get_image(size,color)
	$".".scale = get_size(size)


func get_size(size: String) -> Vector2:
	if size in sprite_size:
		return Vector2(sprite_size[size],sprite_size[size])
	return Vector2(0,0)
	
func get_image(size: String, color: String) -> Texture2D:
	if size in image_data and color in image_data[size]:
		return image_data[size][color]
	return null
		
func _process(delta):
	# Bewege den Asteroiden
	position += direction * speed * delta

func take_damage(amount: int):
	"""
	Wird aufgerufen, wenn der Asteroid Schaden erleidet.
	"""
	health -= amount
	if health <= 0:
		destroy()

func destroy():
	"""
	Zerstört den Asteroiden und erzeugt ggf. einen Drop.
	"""
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true
	if drop_scene:
		var drop_instance = drop_scene.instantiate()
		drop_instance.size = size
		drop_instance.color = color
		drop_instance.position = position
		get_parent().add_child(drop_instance)  # Füge den Drop zur Szene hinzu
	call_deferred_thread_group("queue_free")  # Entferne den Asteroiden aus der Szene
	
func random_color() -> String:
	var colors = ["red", "blue", "green"]
	return colors[randi() % colors.size()]

func random_size() -> String:
	var sizes = ["small", "medium", "large"]
	return sizes[randi() % sizes.size()]
