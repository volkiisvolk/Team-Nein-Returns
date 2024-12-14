extends Node2D

@export var speed = 50.0
var direction = Vector2.ZERO

func _ready():
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()

func _process(delta):
	position += direction * speed * delta
