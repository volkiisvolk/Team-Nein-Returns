extends Node2D

var crafting_inventory: Array[String] = ["null", "null"]
@onready
var node_ship
# Called when the node enters the scene tree for the first time.
# Node2D.gd (das Skript von Node2D)

func _ready():
	node_ship = get_node("../Ship")  # Pfad zum Ship-Node
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(node_ship)
	pass

func reset_inventory() -> void:
	crafting_inventory = ["null", "null"]

# Fügt den Drop dem Inventar hinzu
func add_drop_to_inventory(color: String, size: String) -> void:
	print("Add to inventory")
	print(node_ship)
	print(crafting_inventory)
	#Check ob inventory voll ist (beide Slots belegt)
	if(crafting_inventory[0] == "null"):
		crafting_inventory[0] = color
	elif (crafting_inventory[1] == "null"):
		crafting_inventory[1] = color
		craft_upgrades(color, size)
	
	
# 
func craft_upgrades(color: String, size: String) -> void:
	#Die var node_ship ist für den Zugriff auf das Script ship.
	if(crafting_inventory[1] != "null"):
		
		# Wenn zwei gleiche Farbeb gesammelt wurden -> tank füllen
		if(crafting_inventory[0] == crafting_inventory[1]):
			print("Fuel ADD")
			# TODO der Wert muss der Funktion übergeben werden
			node_ship.refill_fuel(20)
			# Leere das Inventory
			crafting_inventory.clear()
		else:
			match crafting_inventory[0]:
				"red":
					#TODO upgrade_shoot
					crafting_inventory.clear()
				"blue":
					#updgrade_fuel
					node_ship.update_fuel_display()
					crafting_inventory.clear()
				"green":
					#TODO upgrade_speed
					crafting_inventory.clear()
				
				
		
