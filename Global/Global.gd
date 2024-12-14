extends Node

# Globale Variable für den Highscore
var highscore: int = 0

# Methode zum Aktualisieren des Highscores
func update_highscore(score: int) -> void:
	if score > highscore:
		highscore = score
		print("Neuer Highscore: %d" % highscore)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
