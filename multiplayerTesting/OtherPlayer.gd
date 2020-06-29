extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y_velo = 0
const GRAVITY = 0
const MAX_FALL_SPEED = 30

var timeSinceUpdate = 0

onready var messageStuff = $Sprite3D

var lastTransform
var goalTransform

# Called when the node enters the scene tree for the first time.
func _ready():
	lastTransform = transform
	goalTransform = transform
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if goalTransform != null:
		transform.origin = goalTransform.origin
		
		var a = Quat( (lastTransform.basis.orthonormalized()) )
		var b = Quat( (goalTransform.basis.orthonormalized()) ) 
		
		var c = a.slerp(b, min(timeSinceUpdate,.25)/.25)
		
		timeSinceUpdate += delta
		
		transform.origin = lastTransform.origin.linear_interpolate(goalTransform.origin, min(timeSinceUpdate,.25)/.25)
		
		transform.basis = Basis(c)
