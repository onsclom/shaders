extends Sprite3D

onready var messageText = $Viewport/Label/MarginContainer/MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $Viewport.get_texture()
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		updateText("Wow worked!")
	pass
	
func updateText(msg):
	visible = true
	messageText.text = msg
	$Timer.start()

func _on_Timer_timeout():
	visible = false
