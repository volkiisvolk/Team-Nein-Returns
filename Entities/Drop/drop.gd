extends Node2D


## Layer 4 ist Collison für diese Area
@export var color: String  # Eigenschaften des Drops (z. B. Farbe)
@export var size: String  # Größe des Drops (z. B. small, medium, large)

var image_data: Dictionary = {
	"small": {
		"red": preload("res://Entities/Drop/assets/Smallred.png"),
		"green": preload("res://Entities/Drop/assets/Smallgreen.png"),
		"purple": preload("res://Entities/Drop/assets/Smallpurple.png")
	},
	"medium": {
		"red": preload("res://Entities/Drop/assets/Middlered.png"),
		"green": preload("res://Entities/Drop/assets/Middlegreen.png"),
		"purple": preload("res://Entities/Drop/assets/Middlepurple.png")
	},
	"large": {
		"red": preload("res://Entities/Drop/assets/Largered.png"),
		"green": preload("res://Entities/Drop/assets/Large_Green.png"),
		"purple": preload("res://Entities/Drop/assets/Largepurple.png")
	}
}

func _ready():
	# Visuelle Anpassung des Drops (optional)
	modulate_sprite()
	
func get_image(size: String, color: String) -> Texture2D:
	if size in image_data and color in image_data[size]:
		return image_data[size][color]
	print("Is null")
	return null
	
func modulate_sprite():
	$Sprite2D.texture = get_image(size,color)


func _on_Area2D_body_entered(body):
	"""
	Reagiere, wenn ein Spieler das Drop-Objekt einsammelt.
	"""
	if body.name == "Ship":  # Passe den Namen des Spieler-Nodes an
		emit_signal("collected", {"color": color, "size": size})
		queue_free()  # Entferne den Drop aus der Szene
