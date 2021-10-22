extends Control

export(PackedScene) var message_scene
onready var container = $ChatMask/VBoxContainer
var avatars = {}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	WebSocket.connect("chat_signal", self, "_new_message")
	#_new_message({"user":{"username":"Bussy"}, "avatar":"Bitch", "message":"Hey baby"})
	pass
func _new_message(chatMessage):
	var username = chatMessage.user.username
	var icon_path = chatMessage.user.avatar
	var message = chatMessage.message
	
	
	
	
	var label = message_scene.instance()
	container.add_child(label)
	#assign name and message
	label._set_message(username, message)
	label.username = username
	
	#worry about logic for grabbing icon LATER
	if avatars.has(username):
		label.Sprite.texture = avatars[username]

	#timer for self destruction
	label.Timer.connect("timeout", label, "_die")
	label.Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _check_icon(user):
	pass

func _update_avatars():
	print("Updating avatars")
	for i in container.get_children():
		if i.Sprite.texture != null:
			continue
		else:
			pass
			if avatars.has(i.username):
				i.Sprite.texture = avatars[i.username]
				$Sprite.texture = avatars[i.username]
				print(" What is this")
				print(avatars[i.username])
				print("")
