extends Node

# Referenz auf den VBoxContainer
@onready var highscore_container = $CenterContainer/VBoxContainer

func _ready() -> void:
	# Aktualisiere die Highscore-Anzeige beim Start des Menüs
	update_highscore_list()

func update_highscore_list() -> void:
	# Zugriff auf die Highscores aus dem globalen Skript
	var global_script = get_node("/root/Global")
	var highscores = global_script.highscores

	# Entferne alle bisherigen Labels im VBoxContainer
	for child in highscore_container.get_children():
		child.queue_free()

	# Erstelle ein Label für jeden Highscore
	for entry in highscores:
		var label = Label.new()
		label.text = "%s: %d" % [entry["name"], entry["score"]]
		highscore_container.add_child(label)
