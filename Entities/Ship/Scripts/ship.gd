extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	print("dhsuhd " + str(SPEED))


func _physics_process(delta: float) -> void:
	move_and_slide()
	move(delta)
	
	
	
func move(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	position += direction.normalized() * SPEED * delta
		
