extends Node

# The URL we will connect to
# var websocket_url = "ws://echo.websocket.org"
#export var websocket_url = "ws://localhost:8080"
export var websocket_url = "wss://godot-multiplayer-chat.herokuapp.com/" #this is deployed version

# Our WebSocketClient instance
var id
var _client = WebSocketClient.new()

const otherPlayer = preload("res://Other.tscn")
var world
var players = {}

func _ready():
	get_tree().set_auto_accept_quit(false)
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
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	var connectedMessage = {"type": "connected"}
	
	#_client.get_peer(1).put_packet(var2bytes(testMsg))
	_client.get_peer(1).put_packet(JSON.print(connectedMessage).to_utf8())


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_client.disconnect_from_host()
		get_tree().quit() # default behavior

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	
	#print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())
	#var data = bytes2var( _client.get_peer(1).get_packet() )
	
	var data = JSON.parse( _client.get_peer(1).get_packet().get_string_from_utf8() )
	
	if (data.result and data.result.has("type") and data.result["type"] == "connectedResponse"):
		id = data.result["id"]
		print(id)
	elif (data.result and data.result.has("type") and data.result["type"] == "update"):
		#wowee new connection
	
		if players.has(data.result["id"]):
			#player is already created
			players[data.result["id"]].messageStuff.messageText.text = data.result["message"]
			
			players[data.result["id"]].timeSinceUpdate = 0
			players[data.result["id"]].lastTransform = players[data.result["id"]].transform
			players[data.result["id"]].goalTransform = (
				Transform(
					Vector3(
				data.result["transform"][0],
				data.result["transform"][1], 
				data.result["transform"][2]
					),
					Vector3(
				data.result["transform"][3], 
				data.result["transform"][4], 
				data.result["transform"][5]
					),
					Vector3(
				data.result["transform"][6],  
				data.result["transform"][7], 
				data.result["transform"][8]
					),
					Vector3(
				data.result["transform"][9], 
				data.result["transform"][10], 
				data.result["transform"][11]
					)
				)
			)
			
#			players[data.result["id"]].transform[0][0] = players[data.result["transform"]][0]
#			players[data.result["id"]].transform[0][1] = players[data.result["transform"]][1]
#			players[data.result["id"]].transform[0][2] = players[data.result["transform"]][2]
#			players[data.result["id"]].transform[1][0] = players[data.result["transform"]][3]
#			players[data.result["id"]].transform[1][1] = players[data.result["transform"]][4]
#			players[data.result["id"]].transform[1][2] = players[data.result["transform"]][5]
#			players[data.result["id"]].transform[2][0] = players[data.result["transform"]][6]
#			players[data.result["id"]].transform[2][1] = players[data.result["transform"]][7]
#			players[data.result["id"]].transform[2][2] = players[data.result["transform"]][8]
			
		else:
			#need to create player!
			var newPlayer = otherPlayer.instance()
			world.add_child(newPlayer)
			newPlayer.global_transform = world.get_node("Spawn").global_transform
			players[data.result["id"]] = newPlayer
			
			
	elif (data.result and data.result.has("type") and data.result["type"] == "disconnectEvent"):
		if players.has(data.result["id"]):
			players[data.result["id"]].queue_free()
	
#	if data.error == OK:
#		print("good!")
#		print(data.result)
#
#		for x in data.result:
#			print(x)
#	else:
#		print("unexpected results")

func send_message(message):
	var data = {"message": message}
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
	
func do_update(curMsg, transform):
	if id != null:
		var data = {"id":id, "message":curMsg, "type":"update", "transform": [ transform[0][0], transform[0][1], transform[0][2], transform[1][0], transform[1][1], transform[1][2], transform[2][0], transform[2][1], transform[2][2], transform[3][0], transform[3][1], transform[3][2] ]}
		_client.get_peer(1).put_packet(JSON.print(data).to_utf8())
