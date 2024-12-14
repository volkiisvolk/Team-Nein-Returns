extends Node2D

const MAX_RANGE = 5000       # Maximale Länge des Lasers
const TRANSITION_TIME = 3.0  # Zeit in Sekunden für die Farbanimation

var base_width = 10          # Grundbreite des Lasers
var shoot = false            # Schießzustand
var laser_reset = false      # Flag, ob der Laser gerade zurückgesetzt wurde

@onready var line2d   = $Line2D
@onready var collision = $Line2D/DamageArea/CollisionShape2D
@onready var raycast  = $RayCast2D
@onready var reference = $Reference

var tween : Tween = null     # Referenz auf das aktuell laufende Tween (Godot 4.3)

func _ready():
	shoot = false
	collision.disabled = true
	line2d.visible = false

	# Shader initialisieren
	if line2d.material and line2d.material is ShaderMaterial:
		print("ShaderMaterial korrekt erkannt.")
		line2d.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))  # Neon-Hellblau als Startfarbe
		line2d.material.set("shader_parameter/laser_width", 0.1)                       # Anfangsbreite im Shader
	else:
		print("ShaderMaterial fehlt oder nicht korrekt verbunden!")

	# Erste Tween-Animation starten (falls du den Laser schon animiert sehen willst)
	animate_color_transition()


func animate_color_transition():
	# Brich eventuell laufendes Tween ab
	if tween:
		tween.kill()

	# Farbverlauf: Neon-Hellblau -> Neon-Dunkelblau
	var start_color = Color(0.1, 0.9, 1.0, 1.0)
	var target_color = Color(0.0, 0.3, 1.0, 1.0)

	# Nur zu Debug-Zwecken
	print("Starte Farbtransition von:", start_color, "nach:", target_color)

	# Neues Tween erstellen
	tween = create_tween()
	tween.tween_property(
		line2d.material,
		"shader_parameter/laser_color",
		target_color,
		TRANSITION_TIME
	)

	laser_reset = false


func reset_laser():
	# Farbe des Lasers sofort auf Hellblau setzen
	if line2d.material and line2d.material is ShaderMaterial:
		line2d.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))

	print("Laserfarbe zurückgesetzt.")
	laser_reset = true


func _process(delta: float) -> void:
	# ---- Eingabeabfrage (simplified) ----
	if Input.is_action_just_pressed("click"):
		shoot = true
	
	if Input.is_action_just_released("click"):
		shoot = false
		reset_laser()  # Laser nur einmalig beim Loslassen zurücksetzen

	# Wenn der Laser zurückgesetzt ist und wir die Farbtransition noch nicht neu gestartet haben:
	if laser_reset:
		animate_color_transition()

	# ---- RayCast- und Laser-Berechnung ----
	# Position und Richtung relativ zu RayCast2D
	var mouse_pos_local = raycast.to_local(get_global_mouse_position())
	var direction = (mouse_pos_local - raycast.position).normalized()
	raycast.target_position = direction * MAX_RANGE

	# Kollisionsprüfung
	if raycast.is_colliding():
		reference.global_position = raycast.get_collision_point()
		var points = line2d.points
		points[1] = line2d.to_local(reference.global_position)
		line2d.points = points
	else:
		var points = line2d.points
		points[1] = raycast.target_position
		line2d.points = points

	# Dynamische Breite
	var length = line2d.points[1].length()
	line2d.width = base_width + length * 0.01

	# Shader-Parameter aktualisieren
	if line2d.material and line2d.material is ShaderMaterial:
		line2d.material.set("shader_parameter/dynamic_factor", length / float(MAX_RANGE))
		line2d.material.set("shader_parameter/laser_width", line2d.width / 100.0)

	# Kollisionsbereich und Sichtbarkeit
	if shoot:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = line2d.points[1]
		collision.disabled = false
		line2d.visible = true
	else:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = Vector2.ZERO
		collision.disabled = true
		line2d.visible = false
		# Kein doppeltes reset_laser() hier - das passiert jetzt nur in is_action_just_released.
