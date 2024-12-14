extends Node2D

const MAX_RANGE = 1000
const TRANSITION_TIME = 3.0

var base_width = 10
var shoot = false
var laser_reset = false

@onready var line2d    = $Line2D
@onready var collision = $Line2D/DamageArea/CollisionShape2D
@onready var raycast   = $RayCast2D
@onready var reference = $Reference

var tween : Tween = null

func _ready():
	raycast.add_exception(get_parent()) 
	# vorausgesetzt, dein Laser ist Child des Spieler-Nodes,
	# dann ist get_parent() = Player.
	# Laser ist unsichtbar, deaktiviert zu Beginn
	shoot = false
	collision.disabled = true
	line2d.visible = false

	# Inline-Shader erstellen (kombiniert PNG-Textur + Farbmodulation)
	var shader_code = """
		shader_type canvas_item;
		// Additive Mischung für Neon-Effekt, unshaded ignoriert Lichter
		render_mode blend_add, unshaded;

		uniform vec4 laser_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
		uniform float laser_width = 0.5;

		// PNG-Textur (Laser-Look)
		uniform sampler2D laser_texture : hint_albedo;
		// Steuert das UV-Mapping (Kachelung)
		uniform float uv_scale = 1.0;

		void fragment() {
			vec4 tex_color = texture(laser_texture, UV * uv_scale);
			// Laserfarbe und Textur kombinieren
			COLOR = tex_color * laser_color;
		}
	"""

	var laser_shader = Shader.new()
	laser_shader.code = shader_code

	var laser_material = ShaderMaterial.new()
	laser_material.shader = laser_shader

	# PNG-Textur laden (Pfad anpassen an dein Projekt)
	var laser_png = preload("res://Entities/Shoot/Assets/Spirtes/11.png")
	laser_material.set("shader_parameter/laser_texture", laser_png)

	# Material zuweisen
	line2d.material = laser_material

	# Startwerte im Shader
	if line2d.material and line2d.material is ShaderMaterial:
		print("ShaderMaterial erkannt.")
		line2d.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))  # Hellblau
		line2d.material.set("shader_parameter/laser_width", 0.1)
	else:
		print("ShaderMaterial fehlt oder nicht korrekt verbunden!")

	# Farbtransition (Tweens) anwerfen
	animate_color_transition()

func animate_color_transition():
	if tween:
		tween.kill()

	var start_color = Color(0.1, 0.9, 1.0, 1.0)   # Hellblau
	var target_color = Color(0.0, 0.3, 1.0, 1.0)  # Dunkelblau

	tween = create_tween()
	tween.tween_property(
		line2d.material,
		"shader_parameter/laser_color",
		target_color,
		TRANSITION_TIME
	)

	laser_reset = false


func reset_laser():
	# Zurück zu Hellblau
	if line2d.material and line2d.material is ShaderMaterial:
		line2d.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))
	print("Laserfarbe zurückgesetzt.")
	laser_reset = true


func _process(delta: float) -> void:
	# >>> Steuerung: Maustaste drücken/loslassen
	if Input.is_action_just_pressed("click"):
		shoot = true
	
	if Input.is_action_just_released("click"):
		shoot = false
		reset_laser()

	if laser_reset:
		animate_color_transition()

	# >>> Laser-Startpunkt: (0,0) relativ zum Player
	# Da dieser Laser-Node ein Kind vom Player ist, ist Node2D-Position = Spielerposition
	var points = line2d.points
	points[0] = Vector2.ZERO  # Laser beginnt am Spieler

	# >>> RayCast-Berechnung
	# Mausposition in lokale Koordinaten (relative zum Laser-Node -> Player)
	var mouse_pos_local = raycast.to_local(get_global_mouse_position())
	var direction = (mouse_pos_local - raycast.position).normalized()
	raycast.target_position = direction * MAX_RANGE

	if raycast.is_colliding():
		reference.global_position = raycast.get_collision_point()
		points[1] = line2d.to_local(reference.global_position)
	else:
		points[1] = raycast.target_position

	line2d.points = points

	# >>> Dynamische Breite
	var length = points[1].length()
	line2d.width = base_width + length * 0.01

	# >>> Shader-Parameter
	if line2d.material and line2d.material is ShaderMaterial:
		# Skalierung der Textur basierend auf Länge (nur wenn gewünscht)
		# line2d.material.set("shader_parameter/uv_scale", 1.0)
		# Wir passen "laser_width" an line2d.width an, falls du das im Shader nutzen möchtest
		line2d.material.set("shader_parameter/laser_width", line2d.width / 100.0)

	# >>> CollisionShape2D anpassen
	if shoot:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = points[1]
		collision.disabled = false
		line2d.visible = true
	else:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = Vector2.ZERO
		collision.disabled = true
		line2d.visible = false
