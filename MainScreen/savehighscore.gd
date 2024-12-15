extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var name
	$CenterContainer/VBoxContainer/Highscore.set_text("Your Highscore is: "+str(Global.highscore))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_highscore_button_pressed() -> void:
	Global.add_highscore(name,Global.highscore)
	get_tree().change_scene_to_file("res://MainScreen/endscreen.tscn")
	pass # Replace with function body.

func _on_text_edit_text_changed(new_text: String) -> void:
	name = new_text
	pass # Replace with function body.


func _on_nahhh_pressed() -> void:
	get_tree().change_scene_to_file("res://MainScreen/endscreen.tscn")
	pass # Replace with function body.
