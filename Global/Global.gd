extends Node

# Globale Variable für den höchsten Punktestand und den Spielernamen
var highscore: int = 0
var player_name: String = "Volki"  # Standard-Spielername

# max vars
const MAX_SPEED = 1000 # Maximale erlaubte Geschwindigkeit (Tempolimit)
const MAX_DAMAGE = 20 #Maximale erlaubte Damage

# Liste für alle Highscores
var highscores: Array = []  # Liste für mehrere Highscores

# Dateipfad für die Speicherung des Highscores
const HIGHSCORE_FILE: String = "res://User/highscores.json"

# Methode zum Laden aller Highscores
func load_highscores() -> void:
	if FileAccess.file_exists(HIGHSCORE_FILE):
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.READ)
		if file:
			var json_data = file.get_as_text()
			print_debug("Geladene JSON-Daten: %s" % json_data)  # Debug: Zeige den Inhalt der Datei
			file.close()

			# Prüfe, ob die Datei leer ist
			if json_data.is_empty():
				print("Highscore-Datei ist leer.")
				highscores = []
				highscore = 0
				player_name = "Volki"
				return

			# Parse den JSON-Inhalt
			var parsed_data = JSON.parse_string(json_data)
			if typeof(parsed_data) == TYPE_ARRAY:
				# Lade die Liste der Highscores
				highscores = parsed_data
				# Setze den höchsten Punktestand aus der Liste
				if highscores.size() > 0:
					var top_entry = highscores[0]
					highscore = top_entry["score"]
					player_name = top_entry["name"]
				print("Highscores erfolgreich geladen:", highscores)
			else:
				print("Fehler beim Parsen der Highscore-Datei. Unerwartetes Format.")
		else:
			print("Fehler beim Öffnen der Datei.")
	else:
		print("Keine Highscore-Datei gefunden. Leere Liste wird verwendet.")
		highscores = []
		highscore = 0
		player_name = "Volki"

# Methode zum Speichern aller Highscores
func save_highscores() -> void:
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.WRITE)
	if file:
		# Speichere die Liste der Highscores als JSON
		var json_data = JSON.stringify(highscores, "\t")  # Schön formatierte JSON mit Einrückung
		file.store_string(json_data)
		file.close()
		print("Highscores erfolgreich gespeichert:", highscores)
	else:
		print("Fehler beim Speichern der Highscores.")

# Methode zum Hinzufügen oder Aktualisieren eines Highscores
func add_highscore(name: String, score: int) -> void:
	# Überprüfe, ob der Spieler bereits in der Liste existiert
	var found = false
	for highscore_entry in highscores:
		if highscore_entry["name"] == name:
			# Aktualisiere nur, wenn der neue Score höher ist
			if score > highscore_entry["score"]:
				highscore_entry["score"] = score
				print("Highscore aktualisiert: %s - %d" % [name, score])
			else:
				print("Neuer Score für %s ist nicht höher. Keine Aktualisierung." % name)
			found = true
			break

	# Falls der Spieler nicht existiert, füge ihn hinzu
	if not found:
		highscores.append({"name": name, "score": score})
		print("Neuer Highscore hinzugefügt: %s - %d" % [name, score])

	# Sortiere die Liste der Highscores absteigend nach Score
	highscores.sort_custom(Callable(self, "_sort_by_score"))

	# Aktualisiere den höchsten Punktestand und den Spielernamen
	if highscores.size() > 0:
		var top_entry = highscores[0]
		highscore = top_entry["score"]
		player_name = top_entry["name"]

	# Speichere die aktualisierte Liste
	save_highscores()

# Methode zum Aktualisieren des aktuellen Highscores
func update_highscore(score: int) -> void:
	highscore += score
	print("Neuer Highscore: %d, Spielername: %s" % [highscore, player_name])
	# Aktualisiere den Spieler in der Highscore-Liste

# Sortierfunktion für die Highscores
func _sort_by_score(a: Dictionary, b: Dictionary) -> int:
	return b["score"] - a["score"]

# Methode zum Erstellen einer Standard-Highscore-Datei
func save_default_highscores():
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.WRITE)
	if file:
		# Speichere Standardwerte (leere Liste)
		var json_data = JSON.stringify([], "\t")  # Leere Liste als Standard
		file.store_string(json_data)
		file.close()
		print("Highscore-Datei mit Standardwert erstellt.")

# Methode für den ersten Start (nur aufrufen, wenn die Datei fehlt oder leer ist)
func initialize_highscore_file() -> void:
	if not FileAccess.file_exists(HIGHSCORE_FILE):
		save_default_highscores()
	else:
		# Prüfen, ob die Datei leer ist
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.ModeFlags.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			if content.is_empty():
				print("Leere Datei gefunden. Standardwerte werden gespeichert.")
				save_default_highscores()

# Beispiel für den Ablauf beim Start des Spiels
func _ready() -> void:
	print("Highscore-Dateipfad: %s" % ProjectSettings.globalize_path(HIGHSCORE_FILE))  # Debug: Absoluter Pfad
	initialize_highscore_file()
	load_highscores()
	print("Highscore beim Start: %d, Spielername: %s" % [highscore, player_name])

	# Beispiel: Highscores hinzufügen und laden
	add_highscore("Volki", 150)
	add_highscore("Player2", 95)
	add_highscore("Player3", 130)
	print("Aktuelle Highscores:", highscores)
	print("Highscore von Volki:", highscore)
