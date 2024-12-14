extends ParallaxBackground

func _ready():
	randomize()
	_generate_starfield()

func _generate_starfield():
	var parallax_layer = get_node("Stars")
	var star_texture = preload("res://icon.svg") # Sternenbild Textur
	var star_count = 100 # Anzahl der Sterne
	for i in range(star_count):
		var star = Sprite2D.new()
		star.texture = star_texture
		star.position = Vector2(randi_range(-2000, 2000), randi_range(-2000, 2000))
		parallax_layer.add_child(star)
