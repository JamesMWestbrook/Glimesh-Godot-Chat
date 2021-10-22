extends KinematicBody2D

export(float) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_user_input()
	

func _user_input():
	var move = Vector2()
	if Input.is_action_pressed("up"):
		move.y = -1
	if Input.is_action_pressed("down"):
		move.y = 1
	if Input.is_action_pressed("left"):
		move.x = -1
	if Input.is_action_pressed("right"):
		move.x = 1
	
	move_and_collide(move * speed)
	
