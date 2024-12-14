extends Node2D


## Layer 4 ist Collison für diese Area
@export var color: String  # Eigenschaften des Drops (z. B. Farbe)
@export var size: String  # Größe des Drops (z. B. small, medium, large)

func _ready():
	# Visuelle Anpassung des Drops (optional)
	modulate_sprite()

func modulate_sprite():
	# Optional: Ändere die Farbe des Sprites basierend auf der Eigenschaft `color`
	var color_mapping = {"red": Color(1, 0, 0), "blue": Color(0, 0, 1), "green": Color(0, 1, 0)}
	if $Sprite2D and color in color_mapping:
		$Sprite2D.modulate = color_mapping[color]

func _on_Area2D_body_entered(body):
	"""
	Reagiere, wenn ein Spieler das Drop-Objekt einsammelt.
	"""
	if body.name == "Ship":  # Passe den Namen des Spieler-Nodes an
		emit_signal("collected", {"color": color, "size": size})
		queue_free()  # Entferne den Drop aus der Szene
