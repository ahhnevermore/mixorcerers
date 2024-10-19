class_name LocalServer
extends Node

signal localserver_message
var address
var port
var lobby_name
var udp_out_socket
const DEFAULT_CLIENT_PORT = 56472
var allow_discovery:bool
func _init(arg_port:int,arg_lobby_name='Test Lobby'):
	port = arg_port
	lobby_name = arg_lobby_name
	name = "LocalServer"
	
	
#WHEN NOT LOCAL WILL CALL HTTP REQUEST TO THE WEBSERVER WHICH HAS DB CONNECTION	


func _ready():
	localserver_message.emit(["hello"])
	#validate
	if port < 49152 or port > 65535:
		localserver_message.emit(["Error","Invalid Port"])
		windup()
	else:
		#for interface in IP.get_local_interfaces():
			#if interface["friendly"] == "Wi-Fi":
				#address = interface["addresses"][-1]
		#
		
		udp_out_socket = PacketPeerUDP.new()
		udp_out_socket.set_broadcast_enabled(true)
		udp_out_socket.set_dest_address("255.255.255.255", DEFAULT_CLIENT_PORT)
		
		allow_discovery= true
		discovery_ping()
		

		
func _process(_delta):
	pass	


func windup():
#	check all kindsa stuff here
	self.queue_free()
func discovery_ping()->void:
	if allow_discovery:
		udp_out_socket.put_packet(str("Mixorcerers|0.1.0|",port,"|",lobby_name).to_ascii_buffer())
		get_tree().create_timer(1.).timeout.connect(discovery_ping)
	
	
