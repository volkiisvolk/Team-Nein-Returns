extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CenterContainer/VBoxContainer/Highscore.text = "highscore: " + str(Global.highscore)


func _on_back_button_pressed() -> void:
	Global.highscore = 0
	get_tree().change_scene_to_file("res://MainScreen/mainscreen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
