extends Node2D

const MAX_RANGE = 1000
const TRANSITION_TIME = 3.0
const FUEL_USAGE_ON_SHOOT = 0.2 # Spritverbrauch beim schießen

var base_width = 10
var shoot = false
var laser_reset = false
var current_damage =10 # aktueller damage

@onready var line2d    = $Line2D
@onready var collision = $Line2D/DamageArea/CollisionShape2D
@onready var raycast   = $RayCast2D
@onready var reference = $Reference

var tween : Tween = null
var parent_ship = null # Referenz auf ship

func _ready():
	# vorausgesetzt, dein Laser ist Child des Spieler-Nodes,
	# dann ist get_parent() = Player.
	# Laser ist unsichtbar, deaktiviert zu Beginn
	shoot = false
	collision.disabled = true
	line2d.visible = false
	raycast.add_exception(get_parent()) 
	


	var laser_shader : Shader = Shader.new()


	var laser_material = ShaderMaterial.new()
	laser_material.shader = laser_shader

	# PNG-Textur laden (Pfad anpassen an dein Projekt)
	var laser_png = preload("res://Entities/Shoot/Assets/sprites/11.png")
	laser_material.set("shader_parameter/laser_texture", laser_png)

	# Material zuweisen
	line2d.material = laser_material

	# Startwerte im Shader
	if line2d.material and line2d.material is ShaderMaterial:
		
		line2d.material.set("shader_parameter/laser_color", Color(0.1, 0.9, 1.0, 1.0))  # Hellblau
		line2d.material.set("shader_parameter/laser_width", 0.1)

	# Farbtransition (Tweens) anwerfen
	animate_color_transition()

func set_parent_ship(ship):
	parent_ship = ship #Referenz auf das Schiff setzen

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
		
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()


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
		
		# verbrauch sprit in schiff
		if parent_ship:
			parent_ship.refill_fuel(FUEL_USAGE_ON_SHOOT)
		
		if raycast.is_colliding():
			#print("ha")
			var collider = raycast.get_collider()
			if collider:
				var parent_node = collider.get_parent()
				if parent_node and parent_node.has_method("take_damage"):
					parent_node.take_damage(current_damage) 

	else:
		collision.shape.a = Vector2.ZERO
		collision.shape.b = Vector2.ZERO
		collision.disabled = true
		line2d.visible = false

func set_damage(amount: int) -> void:
	current_damage += amount
