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

func _ready() -> void:
	#var viewport_size = get_viewport().get_visible_rect().size
	#hud.position = Vector2(viewport_size.x / 2 - hud.get_child(0).get_size().x / 2, 0)

	# puff puff
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()
	move(delta)
	check_fuel(delta)
	
	
func move(delta):

	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
		#Nur zu testzwecekn
		add_drop_to_inventory("red", "red")
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
		fuel = max(fuel, 0) #Sicherstellen dass fuel > 0

# prüft tank 
func check_fuel(delta):
	if fuel <= 0:
		get_tree().quit() # Spiel ende
		# Hier code für End screen oder so
	else:
		update_fuel_display()

# zeigt fuel an
func update_fuel_display():
	# Bestimme Anzahl der gefüllten Blocks
	var total_blocks = int(max_fuel / 10) # 1 block pro 10 fuel im tank
	var filled_blocks = int((fuel / max_fuel) * total_blocks)
	var empty_blocks = total_blocks - filled_blocks
	
	# Erstelle Anzeige 
	var fuel_bar = " █".repeat(filled_blocks) + " ░".repeat(empty_blocks)
	# Aktualisiere Label
	fuel_label.text = fuel_bar

# ruf das auf von ausen irgendwie
func refill_fuel(amount: float) -> void:
	# füge die gegebene Menge hinzu
	fuel += amount
	# sicherstellen, dass der Tank nicht über das Maximum geht
	fuel = min(fuel, max_fuel) 
	update_fuel_display()

# aufrufen für tank upgrade
func upgrade_tank_capacity(amount: float) -> void:
	max_fuel += amount
	fuel = min(fuel, max_fuel) # fuel ist nicht über max_fuel
	update_fuel_display()
	print("Tankkapazität erhöht auf  %.2f" % max_fuel)

# aufrufen für speed upgrade
func upgrade_speed(amount: float) -> void:
	current_speed += amount
	print("current_speed: %.2f" % current_speed)

# aufrufen für damage Verbesserung
func upgrade_damage(amount: int) -> void:
	bullet_scene.set_damage(amount)



# Logic für das Craften
func reset_inventory() -> void:
	crafting_inventory = ["null", "null"]

# Fügt den Drop dem Inventar hinzu
func add_drop_to_inventory(color: String, size: String) -> void:
	print("Add to inventory")
	print(crafting_inventory)
	#Check ob inventory voll ist (beide Slots belegt)
	if(crafting_inventory[0] == "null"):
		crafting_inventory[0] = color
	elif (crafting_inventory[1] == "null"):
		crafting_inventory[1] = color
		craft_upgrades(color, size)
	
	
func craft_upgrades(color: String, size: String) -> void:
	#Die var node_ship ist für den Zugriff auf das Script ship.
	if(crafting_inventory[1] != "null"):
		
		# Wenn zwei gleiche Farbeb gesammelt wurden -> tank füllen
		if(crafting_inventory[0] == crafting_inventory[1]):
			print("Fuel ADD")
			# TODO der Wert muss der Funktion übergeben werden
			refill_fuel(20)
			# Leere das Inventory
			reset_inventory()
		else:
			match crafting_inventory[0]:
				"red":
					upgrade_damage(10.0)
					reset_inventory()
				"blue":
					#updgrade_fuel
					update_fuel_display()
					reset_inventory()
				"green":
					upgrade_speed(10.0)
					reset_inventory()
				
				
		
