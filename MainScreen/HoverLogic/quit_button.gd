extends Button
# Schriftarten deklarieren
var normal_font: Font
var hover_font: Font

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normal_font = preload("res://MainScreen/Fonts/Squarea Regular.ttf")  # Ersetze den Pfad mit deiner Schriftart
	hover_font = preload("res://MainScreen/Fonts/Squarea Expanded Oblique.ttf")    # Ersetze den Pfad mit der Hover-Schriftart

	# Standard-Schrift setzen
	add_theme_font_override("font", normal_font)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	add_theme_font_override("font", hover_font)


func _on_mouse_exited() -> void:
	add_theme_font_override("font", normal_font)
