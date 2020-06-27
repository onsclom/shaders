extends KinematicBody
 
const MOVE_SPEED = 12
const JUMP_FORCE = 30
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30
 
const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0
 
onready var cam = $Spatial/Camera

onready var msgText = $Control/VBoxContainer/LineEdit
 
var y_velo = 0
 
func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if Input.is_action_just_pressed("type"):
		print("typed!")
		msgText.grab_focus()
	if Input.is_action_just_pressed("esc"):
		msgText.release_focus()
 
func _physics_process(delta):
	var move_vec = Vector3()
	
	if (!msgText.has_focus()):
		if Input.is_action_pressed("move_forwards"):
			move_vec.z -= 1
		if Input.is_action_pressed("move_backwards"):
			move_vec.z += 1
		if Input.is_action_pressed("move_right"):
			rotation_degrees.y -= H_LOOK_SENS*delta*150
		if Input.is_action_pressed("move_left"):
			rotation_degrees.y += H_LOOK_SENS*delta*150
	else:
		#msg has focus
		if Input.is_action_just_pressed("text_enter"):
			msgText.release_focus()
			var msg = msgText.text 
			msgText.text = ""
			WebsocketClient.send_message(msg)
		
		
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	
	y_velo = move_and_slide(move_vec, Vector3(0, 1, 0)).y
   
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump") and !msgText.has_focus():
		just_jumped = true
		y_velo = JUMP_FORCE
	
	if Input.is_action_just_released("jump") and y_velo >= 0:
		y_velo /= 2
		
		
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
