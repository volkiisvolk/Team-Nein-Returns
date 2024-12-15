extends Node

# Referenz auf den VBoxContainer
@onready var highscore_container = $CenterContainer/VBoxContainer/VBoxContainer3
var dynamic_font = FontVariation.new()
func _ready() -> void:
	dynamic_font= load("res://MainScreen/Fonts/Squarea Regular.ttf")
	# Aktualisiere die Highscore-Anzeige beim Start des Menüs
	update_highscore_list()

func update_highscore_list() -> void:
	# Zugriff auf die Highscores aus dem globalen Skript
	var global_script = get_node("/root/Global")
	var highscores = global_script.highscores

	# sortiere highscoreliste nach score
	highscores.sort_custom(func(a, b): return a["score"] > b["score"])

	# Erstelle ein Label für jeden Highscore
	for entry in highscores:
		var label = Label.new()
		label.text = "%s: %d" % [entry["name"], entry["score"]]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font",dynamic_font)
		highscore_container.add_child(label)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://MainScreen/mainscreen.tscn")
	pass # Replace with function body.
