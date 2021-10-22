extends Node2D

export(PackedScene) var npc_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var npc_chatters = {}
var chat_avatars = {}
export (Array, NodePath) var spawns
# Called when the node enters the scene tree for the first time.
func _ready():
	_load_start()
	WebSocket.connect("create_npc", self, "_create_npc")
	WebSocket.connect("color_npc", self, "_change_color")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _load_start():
	print("Loading saved avatars")
	var dir = Directory.new()
	dir.open("user://")
	if !dir.dir_exists("user://avatars/"):
		dir.make_dir("avatars")
	dir.open("user://avatars")
	dir.list_dir_begin()
	var files = []
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	for i in files:
		var username = i.trim_suffix(".png")
		chat_avatars[username] = "user://avatars/" + username + ".png"
		npc_chatters.append(username)
		_create_npc(username, true)
	print("loaded files")


func _create_npc(user, at_start = false):
	var username = user
	if _check_for_npc(username) and !at_start:
		print("user already in game")
		return

	var npc = npc_scene.instance()
	#if !_check_for_npc(username):
	
	get_node(spawns[npc_chatters.size() - 1]).add_child(npc)
	npc_chatters[username] = npc
	npc.name = username
	npc.get_node("Label").text = username
	

func _check_for_npc(username):
	return npc_chatters.has(username)


func _change_color(user, color):
	if !npc_chatters.has(user):
		print("User not in game")
		return
	var color_value 
	match color:
		"red":
			color_value = Color8(255,90,90)
		"lime":
			color_value = Color8(130,255,90)
		"cyan":
			color_value = Color8(90,255,255)
		"blue":
			color_value = Color8(90,110,255)
		"purple":
			color_value = Color8(172,90,255)
		"pink":
			color_value = Color8(255,90,255)
		_:
			print("No good color picked smh")
			return
	var npc = npc_chatters[user]
	var layer = npc.get_node("color_layer")
	layer.modulate = color_value
	print(color_value)
	
	#from_hsv
