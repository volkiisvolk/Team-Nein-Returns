extends Node

# Globale Variable für den Highscore
var highscore: int = 0
var player_name: String = "Volki"  # Standard-Spielername

# Dateipfad für die Speicherung des Highscores
const HIGHSCORE_FILE: String = "res://User/highscore.json"

# Methode zum Laden des Highscores
func load_highscore() -> void:
	if FileAccess.file_exists(HIGHSCORE_FILE):
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.READ)
		if file:
			var json_data = file.get_as_text()
			print_debug("Geladene JSON-Daten: %s" % json_data)  # Debug: Zeige den Inhalt der Datei
			file.close()
			
			# Prüfe, ob die Datei leer ist
			if json_data.is_empty():
				print("Highscore-Datei ist leer.")
				highscore = 0
				player_name = "Volki"
				return
			
			# Parse den JSON-Inhalt
			var parsed_data = JSON.parse_string(json_data)
			if typeof(parsed_data) == TYPE_DICTIONARY:
				# Lade den Highscore und den Namen
				highscore = int(parsed_data.get("score", 0))
				player_name = parsed_data.get("name", "Volki")
				print("Highscore geladen: %d, Spielername: %s" % [highscore, player_name])
			else:
				print("Fehler beim Laden der Highscore-Daten.")
		else:
			print("Fehler beim Öffnen der Datei.")
	else:
		print("Keine Highscore-Datei gefunden. Highscore bleibt auf 0.")
		highscore = 0
		player_name = "Volki"

# Methode zum Speichern des Highscores
func save_highscore() -> void:
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.WRITE)
	if file:
		# Speichere den Highscore und den Namen als JSON
		var json_data = JSON.stringify({
			"name": player_name,
			"score": highscore
		}, "\t")  # Schön formatierte JSON mit Einrückung
		file.store_string(json_data)
		file.close()
		print("Highscore gespeichert: %d, Spielername: %s" % [highscore, player_name])
		print_debug("Gespeicherte JSON-Daten: %s" % json_data)  # Debug: Zeige die gespeicherten Daten
	else:
		print("Fehler beim Speichern des Highscores.")

# Methode zum Aktualisieren des Highscores
func update_highscore(score: int) -> void:
	highscore += score
	print("Neuer Highscore: %d, Spielername: %s" % [highscore, player_name])
	save_highscore()

# Methode zum Erstellen einer Standard-Highscore-Datei
func save_default_highscore():
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.WRITE)
	if file:
		# Speichere Standardwerte (Spielername und Highscore 0)
		var json_data = JSON.stringify({
			"name": "Volki",
			"score": 0
		}, "\t")
		file.store_string(json_data)
		file.close()
		print("Highscore-Datei mit Standardwert erstellt.")

# Methode für den ersten Start (nur aufrufen, wenn die Datei fehlt oder leer ist)
func initialize_highscore_file() -> void:
	if not FileAccess.file_exists(HIGHSCORE_FILE):
		save_default_highscore()
	else:
		# Prüfen, ob die Datei leer ist
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			if content.is_empty():
				print("Leere Datei gefunden. Standardwert wird gespeichert.")
				save_default_highscore()

# Beispiel für den Ablauf beim Start des Spiels
func _ready() -> void:
	print("Highscore-Dateipfad: %s" % ProjectSettings.globalize_path(HIGHSCORE_FILE))  # Debug: Absoluter Pfad
	initialize_highscore_file()
	load_highscore()
	print("Highscore beim Start: %d, Spielername: %s" % [highscore, player_name])
