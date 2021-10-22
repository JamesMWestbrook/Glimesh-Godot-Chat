extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("request_completed", self, "_get_image")
	var http_error = request("https://glimesh-user-assets.nyc3.cdn.digitaloceanspaces.com/uploads/avatars/DairyFreeLemon.png?v=63796954188")
#	var http_error = request("https://via.placeholder.com/500")
	if http_error != OK:
		print("Welp not OK")
	print("send request")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _get_image(result, response_code, headers, body):
	print("Got called")
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("Image isn't okay")
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$TextureRect.texture = texture
	$Sprite.texture = texture
