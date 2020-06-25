extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y_velo = 0
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_vec = Vector3()
	
	move_vec.y = y_velo
	
	y_velo = move_and_slide(move_vec, Vector3(0, 1, 0)).y
   
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	

	pass
