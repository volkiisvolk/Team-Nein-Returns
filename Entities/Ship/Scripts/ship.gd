extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var fuel = 100.0 # Startwert für fuel
var max_fuel = 100.0 # Maximale Tankfüllung

var current_speed = SPEED # Aktuelle Geschwindigkeit
const FUEL_CONSUMPTION_RATE = 5.0 # Spritverbrauch pro Sekunde bei Bewegung 
const FUEL_BLOCKS = 10 # Anzahl der angezeigten Tankblöcke


var sprite_size: Dictionary = {
	"small": 1,
	"medium": 3,
	"large": 7
}

signal fuel_change(fuel_new, fuel_max)
signal speed_change(speed)

@onready var crafting_inventory: Array[String] = ["null", "null"] # crafting inventory
@onready var size_inventory: Array[String] = ["null", "null"] # crafting inventory
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
		#notify ui screen that fuel changed
		fuel_change.emit(fuel, max_fuel)


# ruf das von außen auf
func refill_fuel(amount: float) -> void:
	# Füge die gegebene Menge hinzu
	fuel += amount
	# Sicherstellen, dass der Tank nicht über das Maximum geht
	fuel = min(fuel, max_fuel) 
	fuel_change.emit(fuel, max_fuel)

# aufrufen für Tank-Upgrade
func upgrade_tank_capacity(amount: float) -> void:
	max_fuel += amount
	fuel = min(fuel, max_fuel) # fuel ist nicht über max_fuel
	fuel_change.emit(fuel, max_fuel)
	print("Tankkapazität erhöht auf  %.2f" % max_fuel)

# aufrufen für Speed-Upgrade
func upgrade_speed(amount: float) -> void:
	current_speed += amount
	speed_change.emit(current_speed)
	print("current_speed: %.2f" % current_speed)

# aufrufen für Damage-Verbesserung
func upgrade_damage(amount: int) -> void:
	bullet_scene.set_damage(amount)

"""
Logik für das Craften
"""
func reset_inventory() -> void:
	crafting_inventory = ["null", "null"]
	size_inventory = ["null", "null"]

# Fügt den Drop dem Inventar hinzu
func add_drop_to_inventory(color: String, size: String) -> void:
	# Check, ob Inventory voll ist (beide Slots belegt)
	if crafting_inventory[0] == "null":
		crafting_inventory[0] = color
		size_inventory[0] = size
	elif (crafting_inventory[1] == "null"):
		crafting_inventory[1] = color
		size_inventory[1] = size
		craft_upgrades()
	
func craft_upgrades() -> void:
	var multiplier = sprite_size[size_inventory[0]] * sprite_size[size_inventory[1]]
	#Die var node_ship ist für den Zugriff auf das Script ship.
	if(crafting_inventory[1] != "null"):
		
		# Wenn zwei gleiche Farbeb gesammelt wurden -> tank füllen
		if(crafting_inventory[0] == crafting_inventory[1]):
			print("Fuel ADD")
			# TODO der Wert muss der Funktion übergeben werden
			refill_fuel(20*multiplier)
			# Leere das Inventory
			reset_inventory()
		else:
			if(crafting_inventory.has("purple") and crafting_inventory.has("green")):
				upgrade_tank_capacity(20*multiplier)
			fuel_change.emit(fuel, max_fuel)
			reset_inventory()
			if(crafting_inventory.has("red") and crafting_inventory.has("green")):
				upgrade_speed(20*multiplier)
				reset_inventory()
			if(crafting_inventory.has("red") and crafting_inventory.has("purple")):
				upgrade_damage(20*multiplier)
				reset_inventory()
