extends Node2D

@export var speed = 50.0
@export var size: String = "medium"  # Größe des Asteroiden
@export var color: String = "purple"  # Farbe des Asteroiden
@export var health: int = 100  # Lebenspunkte des Asteroiden
var direction = Vector2.ZERO
var smallValue = 5
var mediumValue = 10
var largeValue = 15


var sprite_size: Dictionary = {
	"small": 0.4,
	"medium": 1,
	"large": 1.6
}

var image_data: Dictionary = {
	"small": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png"),
		"red1": preload("res://Entities/Asteroids/assets/DamageRed/R1.png"),
		"green1": preload("res://Entities/Asteroids/assets/DamageGreen/G (1).png"),
		"purple1": preload("res://Entities/Asteroids/assets/DamagePurple/1.png"),
		"red2": preload("res://Entities/Asteroids/assets/DamageRed/R2.png"),
		"green2": preload("res://Entities/Asteroids/assets/DamageGreen/G (2).png"),
		"purple2": preload("res://Entities/Asteroids/assets/DamagePurple/2.png"),
		"red3": preload("res://Entities/Asteroids/assets/DamageRed/R3.png"),
		"green3": preload("res://Entities/Asteroids/assets/DamageGreen/G (3).png"),
		"purple3": preload("res://Entities/Asteroids/assets/DamagePurple/3.png"),
		"red4": preload("res://Entities/Asteroids/assets/DamageRed/R4.png"),
		"green4": preload("res://Entities/Asteroids/assets/DamageGreen/G (4).png"),
		"purple4": preload("res://Entities/Asteroids/assets/DamagePurple/4.png"),
		"red5": preload("res://Entities/Asteroids/assets/DamageRed/R5.png"),
		"green5": preload("res://Entities/Asteroids/assets/DamageGreen/G (5).png"),
		"purple5": preload("res://Entities/Asteroids/assets/DamagePurple/5.png"),
		"red6": preload("res://Entities/Asteroids/assets/DamageRed/R6.png"),
		"green6": preload("res://Entities/Asteroids/assets/DamageGreen/G (6).png"),
		"purple6": preload("res://Entities/Asteroids/assets/DamagePurple/6.png"),
		"red7": preload("res://Entities/Asteroids/assets/DamageRed/R7.png"),
		"green7": preload("res://Entities/Asteroids/assets/DamageGreen/G (7).png"),
		"purple7": preload("res://Entities/Asteroids/assets/DamagePurple/7.png")
	},
	"medium": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png"),
		"red1": preload("res://Entities/Asteroids/assets/DamageRed/R1.png"),
		"green1": preload("res://Entities/Asteroids/assets/DamageGreen/G (1).png"),
		"purple1": preload("res://Entities/Asteroids/assets/DamagePurple/1.png"),
		"red2": preload("res://Entities/Asteroids/assets/DamageRed/R2.png"),
		"green2": preload("res://Entities/Asteroids/assets/DamageGreen/G (2).png"),
		"purple2": preload("res://Entities/Asteroids/assets/DamagePurple/2.png"),
		"red3": preload("res://Entities/Asteroids/assets/DamageRed/R3.png"),
		"green3": preload("res://Entities/Asteroids/assets/DamageGreen/G (3).png"),
		"purple3": preload("res://Entities/Asteroids/assets/DamagePurple/3.png"),
		"red4": preload("res://Entities/Asteroids/assets/DamageRed/R4.png"),
		"green4": preload("res://Entities/Asteroids/assets/DamageGreen/G (4).png"),
		"purple4": preload("res://Entities/Asteroids/assets/DamagePurple/4.png"),
		"red5": preload("res://Entities/Asteroids/assets/DamageRed/R5.png"),
		"green5": preload("res://Entities/Asteroids/assets/DamageGreen/G (5).png"),
		"purple5": preload("res://Entities/Asteroids/assets/DamagePurple/5.png"),
		"red6": preload("res://Entities/Asteroids/assets/DamageRed/R6.png"),
		"green6": preload("res://Entities/Asteroids/assets/DamageGreen/G (6).png"),
		"purple6": preload("res://Entities/Asteroids/assets/DamagePurple/6.png"),
		"red7": preload("res://Entities/Asteroids/assets/DamageRed/R7.png"),
		"green7": preload("res://Entities/Asteroids/assets/DamageGreen/G (7).png"),
		"purple7": preload("res://Entities/Asteroids/assets/DamagePurple/7.png")
		
	},
	"large": {
		"red": preload("res://Entities/Asteroids/assets/asteroidred.png"),
		"green": preload("res://Entities/Asteroids/assets/asteroidgreen.png"),
		"purple": preload("res://Entities/Asteroids/assets/asteroidpurple.png"),
		"red1": preload("res://Entities/Asteroids/assets/DamageRed/R1.png"),
		"green1": preload("res://Entities/Asteroids/assets/DamageGreen/G (1).png"),
		"purple1": preload("res://Entities/Asteroids/assets/DamagePurple/1.png"),
		"red2": preload("res://Entities/Asteroids/assets/DamageRed/R2.png"),
		"green2": preload("res://Entities/Asteroids/assets/DamageGreen/G (2).png"),
		"purple2": preload("res://Entities/Asteroids/assets/DamagePurple/2.png"),
		"red3": preload("res://Entities/Asteroids/assets/DamageRed/R3.png"),
		"green3": preload("res://Entities/Asteroids/assets/DamageGreen/G (3).png"),
		"purple3": preload("res://Entities/Asteroids/assets/DamagePurple/3.png"),
		"red4": preload("res://Entities/Asteroids/assets/DamageRed/R4.png"),
		"green4": preload("res://Entities/Asteroids/assets/DamageGreen/G (4).png"),
		"purple4": preload("res://Entities/Asteroids/assets/DamagePurple/4.png"),
		"red5": preload("res://Entities/Asteroids/assets/DamageRed/R5.png"),
		"green5": preload("res://Entities/Asteroids/assets/DamageGreen/G (5).png"),
		"purple5": preload("res://Entities/Asteroids/assets/DamagePurple/5.png"),
		"red6": preload("res://Entities/Asteroids/assets/DamageRed/R6.png"),
		"green6": preload("res://Entities/Asteroids/assets/DamageGreen/G (6).png"),
		"purple6": preload("res://Entities/Asteroids/assets/DamagePurple/6.png"),
		"red7": preload("res://Entities/Asteroids/assets/DamageRed/R7.png"),
		"green7": preload("res://Entities/Asteroids/assets/DamageGreen/G (7).png"),
		"purple7": preload("res://Entities/Asteroids/assets/DamagePurple/7.png")
	}
}

@export var drop_scene: PackedScene
@export var spawnprotected = true  # Schutzflag zu Beginn aktiv

func _ready():
	# Initialisiere Lebenspunkte basierend auf der Größe
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	adjust_stats()
	
	# Verbindung des Signals für die Kollisionserkennung
	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	
	adjust_collision_shape()

	await get_tree().create_timer(1.0).timeout  # 2 Sekunden Schutzzeit
	spawnprotected = false
	print("Asteroid ist jetzt nicht mehr geschützt.")

func adjust_stats():
	$Sprite2D.texture = get_image(size,color)
	$".".scale = get_size(size)


func get_size(size: String) -> Vector2:
	if size in sprite_size:
		return Vector2(sprite_size[size],sprite_size[size])
	print("Is null")
	return Vector2(0,0)
	
func get_image(size: String, color: String) -> Texture2D:
	if size in image_data and color in image_data[size]:
		return image_data[size][color]
	print("Is null")
	return null
		
func _process(delta):
	# Bewege den Asteroiden
	position += direction * speed * delta

func take_damage(amount: int):
	"""
	Wird aufgerufen, wenn der Asteroid Schaden erleidet.
	"""
	health -= amount
	
	print(health)

	if size == "small":
		if health < 87.5 and health >= 75.0:
			print(color+"1")
			$Sprite2D.texture = get_image(size,color+"1")
		elif health < 75.0 and health >= 62.5:
			print(color+"2")
			$Sprite2D.texture = get_image(size,color+"2")
		elif health < 62.5 and health >= 50.0:
			print(color+"3")
			$Sprite2D.texture = get_image(size,color+"3")
		elif health < 50.0 and health >= 37.5:
			print(color+"4")
			$Sprite2D.texture = get_image(size,color+"4")
		elif health < 37.5 and health >= 25.0:
			$Sprite2D.texture = get_image(size,color+"5")
		elif health < 25.0 and health >= 12.5: 
			$Sprite2D.texture = get_image(size,color+"6")
		elif health < 12.5 and health >= 0:
			$Sprite2D.texture = get_image(size,color+"7")
			

	if size == "medium":
		if health < 500.0 and health >= 430:
			print(color+"1")
			$Sprite2D.texture = get_image(size,color+"1")
		elif health < 430.0 and health >= 360:
			print(color+"2")
			$Sprite2D.texture = get_image(size,color+"2")
		elif health < 360 and health >= 290:
			print(color+"3")
			$Sprite2D.texture = get_image(size,color+"3")
		elif health < 290 and health >= 220:
			print(color+"4")
			$Sprite2D.texture = get_image(size,color+"4")
		elif health < 220 and health >= 150:
			print(color+"5")
			$Sprite2D.texture = get_image(size,color+"5")
		elif health < 80 and health >= 10: 
			print(color+"6")
			$Sprite2D.texture = get_image(size,color+"6")
		elif health < 10 and health >= 0:
			print(color+"7")
			$Sprite2D.texture = get_image(size,color+"7")
			
	if size == "large":
		if health < 2000 and health >= 1720.0:
			print(color+"1")
			$Sprite2D.texture = get_image(size,color+"1")
		elif health < 1720.0 and health >= 1440.0:
			print(color+"2")
			$Sprite2D.texture = get_image(size,color+"2")
		elif health < 1440.0 and health >= 1160.0:
			print(color+"3")
			$Sprite2D.texture = get_image(size,color+"3")
		elif health < 1160.0 and health >= 880.0:
			print(color+"4")
			$Sprite2D.texture = get_image(size,color+"4")
		elif health < 880.0 and health >= 600.0:
			$Sprite2D.texture = get_image(size,color+"5")
		elif health < 600.0 and health >= 320.0: 
			$Sprite2D.texture = get_image(size,color+"6")
		elif health < 320.0 and health >= 0:
			$Sprite2D.texture = get_image(size,color+"7")

	
	if health <= 0:
		destroy()
		

func destroy():
	"""
	Zerstört den Asteroiden und erzeugt ggf. einen Drop.
	"""
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true
	match size:
		"small": 
			Effects.asteroid_small_destroyed() # sound effect
			Global.update_highscore(smallValue)
		"medium": 
			Effects.asteroid_medium_destroyed()
			Global.update_highscore(mediumValue)
		"large" :
			Effects.asteroid_large_destroyed()
			Global.update_highscore(largeValue)
	if drop_scene:
		var drop_instance = drop_scene.instantiate()
		drop_instance.size = size
		drop_instance.color = color
		drop_instance.position = position
		get_parent().add_child(drop_instance)  # Füge den Drop zur Szene hinzu
	call_deferred_thread_group("queue_free")  # Entferne den Asteroiden aus der Szene


func random_color() -> String:
	var colors = ["red", "blue", "green"]
	return colors[randi() % colors.size()]

func random_size() -> String:
	var sizes = ["small", "medium", "large"]
	return sizes[randi() % sizes.size()]


func _on_area_2d_body_entered(body) -> void:
	if spawnprotected:
		print("Kollision ignoriert: Asteroid ist noch geschützt.")
		return
	if body.name == "Ship":
		on_collision_with_ship(body)

#Reduziert den Fuel des Schiffs bei einer Kollision.
func on_collision_with_ship(ship):
	if ship and ship.has_method("refill_fuel"):
		ship.half_fuel()  # Halbiert den Tank
		print("Ship fuel halfed due to asteroid collision!")
		destroy()

# passt die collision_shape der Asteroiden an die Größe der Sprites an
func adjust_collision_shape():
	if size == "small":
		$Area2D/CollisionShape2D.shape = CircleShape2D.new()
		$Area2D/CollisionShape2D.shape.radius = 250  # Kleiner Radius
	elif size == "medium":
		$Area2D/CollisionShape2D.shape = CircleShape2D.new()
		$Area2D/CollisionShape2D.shape.radius = 200 # Mittlerer Radius
	elif size == "large":
		$Area2D/CollisionShape2D.shape = CircleShape2D.new()
		$Area2D/CollisionShape2D.shape.radius = 160  # Großer Radius
