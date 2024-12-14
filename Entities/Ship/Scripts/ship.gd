extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var fuel = 100.0 # Startwert für fuel
const MAX_FUEL = 100.0 # Maximale Tankfüllung
const FUEL_CONSUMPTION_RATE = 5.0 # Spritverbrauch pro Sekunde bei Bewegung 
const FUEL_BLOCKS = 10 # Anzahl der angezeigten Tankblöcke

@onready var fuel_label = $HUD/FuelLabel
@onready var hud = $HUD

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
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	position += direction.normalized() * SPEED * delta
	
	# Wenn man sich bewegt
	if direction != Vector2.ZERO:
		fuel -= FUEL_CONSUMPTION_RATE * delta
		fuel = max(fuel, 0) #Sicherstellen dass fuel > 0

# prüft tank 
func check_fuel(delta):
	if fuel <= 0:
		print("Tank leer du opfer")
		get_tree().quit() # Spiel ende
		# Hier code für End screen oder so
	else:
		update_fuel_display()
		print("Fuel remaining: %.2f" % fuel)

# zeigt fuel an
func update_fuel_display():
	print("hea")
	# Bestimme Anzahl der gefüllten Blocks
	var filled_blocks = int((fuel / MAX_FUEL) * FUEL_BLOCKS)
	var empty_blocks = FUEL_BLOCKS - filled_blocks
	
	# Erstelle Anzeige 
	var fuel_bar = " █".repeat(filled_blocks) + " ░".repeat(empty_blocks)
	# Aktualisiere Label
	fuel_label.text = fuel_bar

# ruf das auf von ausen irgendwie
func refill_fuel(amount: float) -> void:
	# füge die gegebene Menge hinzu
	fuel += amount
	# sicherstellen, dass der Tank nicht über das Maximum geht
	fuel = min(fuel, MAX_FUEL) 
	update_fuel_display()
	
