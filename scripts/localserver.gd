class_name LocalServer
extends Node

var address
var udp_peer
func _init(port:int=49500):
	#set address
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
#WHEN NOT LOCAL WILL CALL HTTP REQUEST TO THE WEBSERVER WHICH HAS DB CONNECTION	


func _ready():
	pass

func windup():
#	check all kindsa stuff here
	self.queue_free()
