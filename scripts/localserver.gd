class_name LocalServer
extends Node

signal localserver_message
var address
var port
var udp_peer


func _init(port:int):
	self.port = port
	
#WHEN NOT LOCAL WILL CALL HTTP REQUEST TO THE WEBSERVER WHICH HAS DB CONNECTION	


func _ready():
	localserver_message.emit(["hello"])
	if port < 49152 or port > 65535:
		self.port = -1
	else:
		pass
	for interface in IP.get_local_interfaces():
		if interface["friendly"] == "Wi-Fi":
			address = interface["addresses"][-1]
	
	udp_peer = PacketPeerUDP.new()
	var error = udp_peer.bind(port,address)
	match error:
		OK:
			pass
		_:
			print(error)

func windup():
#	check all kindsa stuff here
	self.queue_free()
