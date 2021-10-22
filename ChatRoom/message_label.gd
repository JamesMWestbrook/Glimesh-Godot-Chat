extends Label

onready var Timer = $Timer
onready var Sprite = $Sprite
var username
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _die():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _set_message(username, message):
	text = username + ": " + message

func _set_avatar(texture):
	Sprite.texture = texture
