extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button_click():
	$"Click".play()

func asteroid_small_destroyed():
	$Asteroid_small.play()

func asteroid_medium_destroyed():
	$Asteroid_medium.play()

func asteroid_large_destroyed():
	$Asteroid_large.play()

func death():
	$Tod.play()

func fuel():
	$Fuel.play()

func damage_upgrade():
	$Shotpower_upgrade.play()

func speed_upgrade():
	$Speed_upgrade.play()

func tank_upgrade():
	$Tank_upgrade.play()
