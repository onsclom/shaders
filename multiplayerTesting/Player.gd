extends KinematicBody
 
const MOVE_SPEED = 12
const JUMP_FORCE = 30
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30
 
const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0
 
onready var cam = $Spatial/Camera

onready var msgText = get_node("../../../Control/VBoxContainer/LineEdit")
onready var joystick = get_node("../../../Control/Joystick")

var curMsg = ""
var isTyping = false
 
var y_velo = 0
 
func _ready():
	pass
	WebsocketClient.player = self
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if Input.is_action_just_pressed("type"):
		print("typed!")
		msgText.grab_focus()
	if Input.is_action_just_pressed("esc"):
		msgText.release_focus()
 
func _physics_process(delta):
	var move_vec = Vector3()
	
	if (msgText != null and !msgText.has_focus()):
		isTyping = false
		if Input.is_action_pressed("move_forwards") or joystick.output.y < -.3:
			move_vec.z -= 1
		if Input.is_action_pressed("move_backwards") or joystick.output.y > .3:
			move_vec.z += 1
		if Input.is_action_pressed("move_right") or joystick.output.x > .3:
			rotation_degrees.y -= H_LOOK_SENS*delta*150
		if Input.is_action_pressed("move_left") or joystick.output.x < -.3:
			rotation_degrees.y += H_LOOK_SENS*delta*150
	else:
		isTyping = true
		#msg has focus
		if Input.is_action_just_pressed("text_enter"):
			msgText.release_focus()
			curMsg = msgText.text 
			msgText.text = ""
			msgText.placeholder_text = curMsg
			msgText.get_node("MsgTimer").start()
			WebsocketClient.send_message(curMsg)
		
		
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

func _on_Timer2_timeout():
	msgText.placeholder_text = "/ to type"
	curMsg = ""
	pass # Replace with function body.

func _on_UpdateTimer_timeout():
	WebsocketClient.do_update(isTyping, curMsg, get_global_transform())
		
