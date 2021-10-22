extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var data
export(String, FILE) var key 
export(String) var channel_request
# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var data_to_send = {
	"query" :{
		"user(username: 'DairyFreeLemon') " : "username, id"
	}
}

func _on_Button_button_down():
	var url = "https://glimesh.tv/api/graph"
	var headers = ["Authorization: Client-ID " + _load()]
	var query = JSON.print(data_to_send)
	#print(query)
	#$HTTPRequest.request(url, headers,false,HTTPClient.METHOD_POST, data)
	$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_POST, channel_request)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)


func _load():
	var file = File.new()
	file.open(key, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
