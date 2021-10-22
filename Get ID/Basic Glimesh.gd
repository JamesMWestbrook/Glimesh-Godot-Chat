extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var channel_request
var new_request = String('query {  channel(streamerUsername: "bitch") {    id  }}')
export(String) var username
# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")


func _on_Button_button_down():
	var url = "https://glimesh.tv/api/graph"
	var headers = ["Authorization: Client-ID " + WebSocket.client_id]
	
	new_request = new_request.replace("bitch", username)
	$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_POST, new_request)
	
func _on_request_completed(result, response_code, headers, body):
	print("here is request")
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)



