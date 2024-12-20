extends CharacterBody2D

const SPEED = 200.0 # Startwert für Speed
const MAX_SPEED = Global.MAX_SPEED # Maximale erlaubte Geschwindigkeit (Tempolimit)
const JUMP_VELOCITY = -400.0
const MAX_DAMAGE = Global.MAX_DAMAGE #Maximale erlaubte Damage

var fuel = 100.0 # Startwert für fuel
var max_fuel = 100.0 # Maximale aktuelle Tankfüllung
const MAX_FUEL_CAP = 500 # Maximal erreichbare Tankfüllung
var current_speed = SPEED # Aktuelle Geschwindigkeit
const FUEL_CONSUMPTION_RATE = 2.0 # Spritverbrauch pro Sekunde bei Bewegung 
const FUEL_BLOCKS = 10 # Anzahl der angezeigten Tankblöcke

var sprite_size: Dictionary = {
	"small": 1,
	"medium": 3,
	"large": 7
}

signal inventory_change(color, craft)
signal fuel_change(fuel_new, fuel_max)
signal speed_change(speed)
signal damage_change(damage)

@onready var crafting_inventory: Array[String] = ["null", "null"] # crafting inventory
@onready var size_inventory: Array[String] = ["null", "null"] # crafting inventory
@onready var fuel_label = $HUD/FuelLabel
@onready var hud = $HUD
@onready var bullet_scene = $Laser
@onready var laser = $Laser 
@onready var sprite = $Sprite # Node des Sprites (falls vorhanden)

# Konstanten für Bewegung
var acceleration: float = 1200.0  # Beschleunigungsrate
var deceleration: float = 600.0   # Verzögerungsrate
const FRICTION: float = 0.98      # Trägheitsfaktor für sanftes Abbremsen


func _ready() -> void:
	laser.set_parent_ship(self)

func _physics_process(delta: float) -> void:
	move_and_slide()
	move(delta)
	check_fuel(delta)
	update_rotation(delta) # Smooth Rotation hinzufügen
	
func move(delta):
	var direction = Vector2.ZERO

	# Eingaben korrekt kombinieren
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Richtung normalisieren
	direction = direction.normalized()

	# Bewegung mit gezielter Beschleunigung oder Bremskraft
	if direction != Vector2.ZERO:
		# Sanfte, gezielte Beschleunigung in die Eingaberichtung
		velocity = velocity.lerp(direction * current_speed, 0.25)  # 0.6 = starker Richtungswechsel
		fuel -= FUEL_CONSUMPTION_RATE * delta
		fuel = max(fuel, 0)
	else:
		# Schnellere Verzögerung bei Loslassen der Eingaben
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta * 1.5)

	# Geschwindigkeit begrenzen auf `current_speed`
	velocity = velocity.limit_length(current_speed)

	# Bewegung anwenden
	move_and_slide()


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
		Effects.death()
		get_tree().change_scene_to_file("res://MainScreen/savehighscorescene.tscn")
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
	if amount > 0:
		Effects.fuel() # sound effect

# Halbiert die Tankfüllung
func half_fuel() -> void:
	if(fuel < max_fuel /2):
		Effects.death()
		get_tree().change_scene_to_file("res://MainScreen/savehighscorescene.tscn")
	else:
		fuel = fuel / 2

# aufrufen für Tank-Upgrade
func upgrade_tank_capacity(amount: float) -> void:
	if max_fuel < MAX_FUEL_CAP:
		Effects.tank_upgrade() # sound effect
		max_fuel += amount
		fuel = min(fuel, max_fuel) # fuel ist nicht über max_fuel
		fuel_change.emit(fuel, max_fuel)
		print("Tankkapazität erhöht auf  %.2f" % max_fuel)

# aufrufen für Speed-Upgrade
func upgrade_speed(amount: float) -> void:
	if current_speed < MAX_SPEED:
		Effects.speed_upgrade() #sound effect
		current_speed += amount
		if current_speed > 500:
			current_speed = 500
		speed_change.emit(current_speed)
		print("current_speed: %.2f" % current_speed)

# aufrufen für Damage-Verbesserung
func upgrade_damage(amount: int) -> void:
	print("amount " + str(amount))
	if amount < MAX_DAMAGE:
		Effects.damage_upgrade() # sound effect
		bullet_scene.set_damage(amount)
		var damage = bullet_scene.get_damage()
		damage_change.emit(damage)




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
		inventory_change.emit(color, "")
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
			refill_fuel(40*multiplier)
			inventory_change.emit("", "fuel")
			# Leere das Inventory
			reset_inventory()
		else:
			if(crafting_inventory.has("purple") and crafting_inventory.has("green")):
				upgrade_tank_capacity(10*multiplier)
				fuel_change.emit(fuel, max_fuel)
				inventory_change.emit("", "tank")
				reset_inventory()
			if(crafting_inventory.has("red") and crafting_inventory.has("green")):
				upgrade_speed(2*multiplier)
				inventory_change.emit("", "speed")
				reset_inventory()
			if(crafting_inventory.has("red") and crafting_inventory.has("purple")):
				upgrade_damage(1*multiplier)
				inventory_change.emit("", "damage")
				reset_inventory()
