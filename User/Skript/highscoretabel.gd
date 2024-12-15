extends Node

# Globale Variable für den Highscore
var highscore: int = Global.highscore

# Dateipfad für die Speicherung des Highscores
const HIGHSCORE_FILE: String = "user://highscore.json"

# Methode zum Laden des Highscores beim Start
func load_highscore() -> void:
	if FileAccess.file_exists(HIGHSCORE_FILE):
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.READ)
		if file:
			var json_data = file.get_as_text()
			file.close()
			if json_data:
				var parsed_data = JSON.parse_string(json_data)
				if parsed_data.error == OK:
					highscore = parsed_data.result
					print("Highscore geladen: %d" % highscore)
				else:
					print("Fehler beim Laden des Highscores:", parsed_data.error_string)
	else:
		print("Keine Highscore-Datei gefunden. Highscore bleibt auf 0.")

# Methode zum Speichern des Highscores
func save_highscore() -> void:
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.WRITE)
	if file:
		var json_data = JSON.stringify(highscore)
		file.store_string(json_data)
		file.close()
		print("Highscore gespeichert: %d" % highscore)

# Methode zum Aktualisieren des Highscores
func update_highscore(score: int) -> void:
	highscore += score
	print("Neuer Highscore: %d" % highscore)
	save_highscore()
