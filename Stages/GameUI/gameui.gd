extends CanvasLayer

@onready var fuel_label = $VBoxContainer/FuelSprite/FuelLabel
@onready var speed_label = $VBoxContainer/Speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		$Score.text = str(Global.highscore)
		


func _on_ship_fuel_change(fuel_new: Variant, fuel_max: Variant) -> void:
	update_fuel_display(fuel_new, fuel_max)


# zeigt fuel an
func update_fuel_display(fuel: Variant, max_fuel: Variant):
	# Bestimme Anzahl der gefüllten Blocks
	var total_blocks = int(max_fuel / 10) # 1 Block pro 10 fuel im Tank
	var filled_blocks = int((fuel / max_fuel) * total_blocks)
	var empty_blocks = total_blocks - filled_blocks
	
	# Erstelle Anzeige 
	var fuel_bar = " █".repeat(filled_blocks) + " ░".repeat(empty_blocks)
	# Aktualisiere Label
	fuel_label.text = fuel_bar


func _on_ship_speed_change(speed: Variant) -> void:
	speed_label.text = "speed upgrade: " + str(speed)
	
