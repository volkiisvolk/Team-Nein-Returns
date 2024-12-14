extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var fuel = 100.0 # Startwert für fuel
var max_fuel = 100.0 # Maximale Tankfüllung

var current_speed = SPEED # Aktuelle Geschwindigkeit
const FUEL_CONSUMPTION_RATE = 5.0 # Spritverbrauch pro Sekunde bei Bewegung 
const FUEL_BLOCKS = 10 # Anzahl der angezeigten Tankblöcke

@onready var crafting_inventory: Array[String] = ["null", "null"] # crafting inventory
@onready var fuel_label = $HUD/FuelLabel
@onready var hud = $HUD
@onready var bullet_scene = $Laser

@onready var laser = $Laser 
@onready var sprite = $Sprite # Node des Sprites (falls vorhanden)

func _ready() -> void:
	laser.set_parent_ship(self)

func _physics_process(delta: float) -> void:
	move_and_slide()
	move(delta)
	check_fuel(delta)
	update_rotation(delta) # Smooth Rotation hinzufügen
	
func move(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	position += direction.normalized() * current_speed * delta
	
	# Wenn man sich bewegt
	if direction != Vector2.ZERO:
		fuel -= FUEL_CONSUMPTION_RATE * delta
		fuel = max(fuel, 0) # Sicherstellen, dass fuel > 0

# Smooth Rotation zur Mausposition
func update_rotation(delta: float) -> void:
	# Position der Maus relativ zum Schiff
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = mouse_position - global_position
	
	# Winkel zur Maus berechnen
	var target_rotation = direction_to_mouse.angle()
	
	# Smooth rotation mit Interpolation
	rotation = lerp_angle(rotation, target_rotation, 10 * delta)
	if sprite:
		sprite.rotation = rotation # Sprite folgt der Rotation

# prüft Tank
func check_fuel(delta):
	if fuel <= 0:
		get_tree().change_scene_to_file("res://MainScreen/endscreen.tscn")
		# Hier Code für Endscreen oder so
	else:
		update_fuel_display()

# zeigt fuel an
func update_fuel_display():
	# Bestimme Anzahl der gefüllten Blocks
	var total_blocks = int(max_fuel / 10) # 1 Block pro 10 fuel im Tank
	var filled_blocks = int((fuel / max_fuel) * total_blocks)
	var empty_blocks = total_blocks - filled_blocks
	
	# Erstelle Anzeige 
	var fuel_bar = " █".repeat(filled_blocks) + " ░".repeat(empty_blocks)
	# Aktualisiere Label
	fuel_label.text = fuel_bar

# ruf das von außen auf
func refill_fuel(amount: float) -> void:
	# Füge die gegebene Menge hinzu
	fuel += amount
	# Sicherstellen, dass der Tank nicht über das Maximum geht
	fuel = min(fuel, max_fuel) 
	update_fuel_display()

# aufrufen für Tank-Upgrade
func upgrade_tank_capacity(amount: float) -> void:
	max_fuel += amount
	fuel = min(fuel, max_fuel) # fuel ist nicht über max_fuel
	update_fuel_display()
	print("Tankkapazität erhöht auf  %.2f" % max_fuel)

# aufrufen für Speed-Upgrade
func upgrade_speed(amount: float) -> void:
	current_speed += amount
	print("current_speed: %.2f" % current_speed)

# aufrufen für Damage-Verbesserung
func upgrade_damage(amount: int) -> void:
	bullet_scene.set_damage(amount)

"""
Logik für das Craften
"""
func reset_inventory() -> void:
	crafting_inventory = ["null", "null"]

# Fügt den Drop dem Inventar hinzu
func add_drop_to_inventory(color: String, size: String) -> void:
	# Check, ob Inventory voll ist (beide Slots belegt)
	if crafting_inventory[0] == "null":
		crafting_inventory[0] = color
	elif crafting_inventory[1] == "null":
		crafting_inventory[1] = color
		craft_upgrades(color, size)
	
func craft_upgrades(color: String, size: String) -> void:
	# Wenn das Inventory voll ist
	if crafting_inventory[1] != "null":
		# Wenn zwei gleiche Farben gesammelt wurden -> Tank füllen
		if crafting_inventory[0] == crafting_inventory[1]:
			print("Fuel ADD")
			refill_fuel(20)
			reset_inventory()
		else:
			match crafting_inventory[0]:
				"red":
					upgrade_damage(10.0)
					reset_inventory()
				"blue":
					update_fuel_display()
					reset_inventory()
				"green":
					upgrade_speed(10.0)
					reset_inventory()
