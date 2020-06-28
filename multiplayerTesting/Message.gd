extends Sprite3D

onready var messageText = $Viewport/Label/MarginContainer/MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	messageText.text = ""
	texture = $Viewport.get_texture()
	pass # Replace with function body.
	
func _process(delta):
	if messageText.text == "":
		visible = false
	else:
		visible = true
