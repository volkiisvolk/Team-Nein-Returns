extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# puff puff
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	Effects.button_click()
	get_tree().change_scene_to_file("res://Stages/MainGame/game.tscn")


func _on_options_button_pressed() -> void:
	Effects.button_click()
	get_tree().change_scene_to_file("res://MainScreen/Options.tscn")


func _on_quit_button_pressed() -> void:
	Effects.button_click()
	get_tree().quit() 


func _on_highscore_button_pressed() -> void:
	Effects.button_click()
	get_tree().change_scene_to_file("res://User/highscoretabel.tscn")
	pass # Replace with function body.
