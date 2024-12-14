extends Node2D

const maxrange = 5000  # Maximale Länge des Laserstrahls
const TRANSITION_TIME = 3.0  # Zeit in Sekunden für die Farbanimation

var based_width = 10  # Grundbreite des Lasers
var shoot = false
var resetet
@onready var collision = $Line2D/DamageArea/CollisionShape2D

func _ready():
	shoot = false
	collision.disabled = true
	$Line2D.visible = false

	# Shader initialisieren
	if $Line2D.material and $Line2D.material is ShaderMaterial:
		print("ShaderMaterial korrekt erkannt.")

		# Neon-Hellblau als Startfarbe setzen
		$Line2D.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))  # Neon-Hellblau
		$Line2D.material.set("shader_parameter/laser_width", 0.1)  # Breite setzen
	else:
		print("ShaderMaterial fehlt oder nicht korrekt verbunden!")

	# Tween-Animation starten
	animate_color_transition()


func animate_color_transition():
	const start_color = Color(0.1, 0.9, 1.0, 1.0)
	# Ziel ist Neon-Dunkelblau
	var target_color = Color(0.0, 0.3, 1.0, 1.0)  # Neon-Dunkelblau
	# Start ist die aktuelle Laserfarbe
	print("Startfarbe:", start_color)
	print("Zielwert:", target_color)
	resetet = false

	# Erstelle und starte die Tween-Animation
	var tween = create_tween()
	tween.tween_property(
		$Line2D.material,
		"shader_parameter/laser_color",
		target_color,
		TRANSITION_TIME
	)
	print("Tween erstellt und gestartet!")

func reset_laser():
	# Laser zurücksetzen auf Neon-Hellblau
	if $Line2D.material and $Line2D.material is ShaderMaterial:
		$Line2D.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))  # Neon-Hellblau
	print("Laserfarbe zurückgesetzt.")
	resetet = true

func _process(delta):
	if resetet:
		animate_color_transition()
	
	# Zielposition des RayCasts berechnen, relativ zur aktuellen Node-Position
	var mouse_position = $RayCast2D.to_local(get_global_mouse_position())
	var direction = (mouse_position - $RayCast2D.position).normalized() # Richtung zur Maus
	var max_cast_to = direction * maxrange  # Maximale Reichweite in die Richtung
	$RayCast2D.target_position = max_cast_to

	# Prüfen, ob der RayCast eine Kollision erkannt hat
	if $RayCast2D.is_colliding():
		$Reference.global_position = $RayCast2D.get_collision_point()
		var points = $Line2D.points
		points[1] = $Line2D.to_local($Reference.global_position)  # Kollisionspunkt in lokale Koordinaten umwandeln
		$Line2D.points = points
	else:
		var points = $Line2D.points
		points[1] = $RayCast2D.target_position  # Zielposition des RayCasts setzen
		$Line2D.points = points

	# Dynamische Breite basierend auf der Entfernung
	var length = $Line2D.points[1].length()
	$Line2D.width = based_width + length * 0.01

	# Shader-Parameter dynamisch setzen
	if $Line2D.material and $Line2D.material is ShaderMaterial:
		$Line2D.material.set("shader_parameter/dynamic_factor", length / maxrange)
		$Line2D.material.set("shader_parameter/laser_width", $Line2D.width / 100.0)  # Breite im Shader aktualisieren

	# Kollisionsbereich anpassen
	if shoot:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = $Line2D.points[1]
		collision.disabled = false
		$Line2D.visible = true
	else:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = Vector2.ZERO
		collision.disabled = true
		$Line2D.visible = false
		reset_laser()

	# Eingabe für das Schießen
	if Input.is_action_pressed("click"):
		shoot = true
	else:
		shoot = false
		reset_laser()  # Laser zurücksetzen, wenn nicht geschossen wird
