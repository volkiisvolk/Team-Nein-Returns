extends Node2D

@export var speed = 50.0
@export var size: String = "medium"  # Größe des Asteroiden
@export var color: String = "purple"  # Farbe des Asteroiden
@export var health: int = 100  # Lebenspunkte des Asteroiden
var direction = Vector2.ZERO



var sprite_size: Dictionary = {
	"small": 1,
	"medium": 3,
	"large": 7
}

@export var drop_scene: PackedScene

func _ready():
	# Initialisiere Lebenspunkte basierend auf der Größe
	
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	adjust_stats()
	
	# Verbindung des Signals für die Kollisionserkennung
	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	
func adjust_stats():
	#TODO Verschiedene Texturen hier laden
	var color_mapping = {"red": Color(1, 0, 0), "purple": Color(0, 0, 1), "green": Color(0, 1, 0)}
	if $Sprite2D and color in color_mapping:
		$Sprite2D.modulate = color_mapping[color]
	

	if $"." and size in sprite_size:
		$".".apply_scale(Vector2(sprite_size[size],sprite_size[size]))

		
		
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


func _on_area_2d_body_entered(body) -> void:
	if body.name == "Ship":
		on_collision_with_ship(body)

#Reduziert den Fuel des Schiffs bei einer Kollision.
func on_collision_with_ship(ship):
	if ship and ship.has_method("refill_fuel"):
		ship.refill_fuel(-10)  # Reduziert den Tank um 10 Einheiten
		print("Ship fuel reduced due to asteroid collision!")
		#destroy()
