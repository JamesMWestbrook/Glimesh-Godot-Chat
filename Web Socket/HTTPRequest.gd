extends HTTPRequest

var url = "https://glimesh.tv/api/graph"
var header_start = "Authorization: Client-ID "
var header = []
var key_value

var avatar_query
var username

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _get_thing(type, user, arg):
	username = user
	key_value = WebSocket.client_id
	header = [header_start + key_value]
	match (type):
		"avatar":
			print("arg ",arg)
			connect("request_completed", self, "_get_image")
			var http_error = request(arg)
		#	var http_error = request("https://via.placeholder.com/500")
			if http_error != OK:
				print("Welp not OK")
			
			
func _get_image(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("Image isn't okay")
		
	_check_directory("avatars")
	
	image.save_png("user://avatars/" + username + ".png")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	disconnect("request_completed", self, "_get_image")
	
	if ChatRoom.avatars.has(username):
		pass
	else:
		ChatRoom.avatars[username] = texture
		ChatRoom._update_avatars()


func _check_directory(folder):
	var dir = Directory.new()
	if !dir.dir_exists("user://" + folder +"/"):
		dir.open("user://")
		dir.make_dir(folder)

func _check_file(path):
	pass
