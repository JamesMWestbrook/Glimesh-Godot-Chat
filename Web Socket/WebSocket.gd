extends Node

# The URL we will connect to
var socket_start = "wss://glimesh.tv/api/socket/websocket?vsn=2.0.0&client_id="
export(String, FILE) var key 
var key_value
var websocket_url
# Our WebSocketClient instance
var _client = WebSocketClient.new()

signal chat_signal(array)
signal create_npc(user)
signal color_npc(user, color)


var request = ["1","1","__absinthe__:control","phx_join",{}]
var join_chat_query = ["1","1",
	"__absinthe__:control","doc",
	{"query":"subscription{ chatMessage(channelId: 16414) { user { username avatar avatarURL } message } }",
	"variables":{} }]
var heartbeat = ["1","1","phoenix","heartbeat",{}]



func _ready():
	websocket_url = socket_start + _load()
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	
	var packet = _make_packet(request)
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	_client.get_peer(1).put_packet(packet)
	
	yield(_client,"data_received")
	packet = _make_packet(join_chat_query)
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	_client.get_peer(1).put_packet(packet)
	
	yield(_client,"data_received")
	_heart_beat_send()

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var message = _client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", message)
	print("")
	var m = JSON.parse(message)
	var result = m.result[4]
	
	print("Result : ",m.result[4])
	#if this is a chat message
	if(result.has("result")):
		var chat_message = m.result[4].result.data.chatMessage
		
		print("'",chat_message.message,"'", " from: ", chat_message.user.username)
		emit_signal("chat_signal", chat_message)
		_check_message(chat_message)
		#print("")
		#var dir = Directory.new()
		#if !dir.file_exists("user://avatars/" + chat_message.user.username + ".png"):
		#	$HTTPRequest._get_thing("avatar",chat_message.user.username,chat_message.user.avatarURL)
		#else:
		#	ChatRoom._update_avatars()
		
		
		
func _check_message(chat_message):
	var message = chat_message.message
	var username = chat_message.user.username
	if message.begins_with("!npc create"):
		print("NPC Create Command run by: ", username)
		emit_signal("create_npc",username)
	elif message.begins_with("!npc color"):
		var color = message.trim_prefix("!npc color ")
		emit_signal("color_npc", username, color)

var timer = 0
func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
	
	#every 20 seconds send heartbeat
	timer += delta
	if timer >= 20:
		timer = 0
		_heart_beat_send()

func _load():
	var file = File.new()
	file.open(key, File.READ)
	var content = file.get_as_text()
	file.close()
	key_value = content
	return content

func _heart_beat_send():
	var packet = _make_packet(heartbeat)
	_client.get_peer(1).put_packet(packet)
	
func _make_packet(text):
	return JSON.print(text).to_utf8()
