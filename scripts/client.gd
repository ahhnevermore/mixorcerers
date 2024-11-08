class_name Client
extends Control

func unload_scene(hscene:Node,hard:=false)->void:
	if is_instance_valid(hscene):
		if hard:
			remove_child(hscene)
		else:
			hscene.hide()

func _ready()->void:
	main_menu_scene = load("res://scenes/main_menu.tscn")
	game_scene = load("res://scenes/Game/game.tscn")
	local_multiplayer_scene = load("res://scenes/local_multiplayer.tscn")
	
	multiplayer.peer_connected.connect(_on_client_connected)
	multiplayer.peer_disconnected.connect(_on_client_disconnected)
	multiplayer.connected_to_server.connect(_on_server_connected_ok)
	multiplayer.connection_failed.connect(_on_server_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	load_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass

#MAIN MENU
var main_menu_scene:PackedScene
var hmain_menu:Control
var is_local:=false

func load_main_menu()->void:
	if is_instance_valid(hmain_menu):
				hmain_menu.show()
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hmain_menu = main_menu_scene.instantiate()
		
		hmain_menu.get_node("LaunchGameDebug").pressed.connect(_on_launchgame_pressed)
		hmain_menu.get_node("LocalMultiplayer").pressed.connect(_on_local_multiplayer_pressed)
		
		add_child(hmain_menu)

func _on_launchgame_pressed()->void:
	unload_scene(hmain_menu)
	load_game()

func _on_local_multiplayer_pressed()->void:
	unload_scene(hmain_menu)
	load_local_multiplayer()
	is_local = true
#------------------
#GAME
var game_scene:PackedScene
var hgame:Node

func load_game()->void:
	if is_instance_valid(hgame):
			hgame.show()
	else:
		set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)
		hgame = game_scene.instantiate()
		add_child(hgame)

#-------------------
#LOCAL MULTIPLAYER

var local_multiplayer_scene:PackedScene
var hlocal_multiplayer:Control

var udp_server_socket:PacketPeerUDP
var udp_client_socket:PacketPeerUDP
var allow_discovery:=false
var port:int
var lobby_name:String
const DEFAULT_CLIENT_PORT = 56472
const MAX_CONNECTIONS =20
func load_local_multiplayer()->void:
	if is_instance_valid( hlocal_multiplayer):
		hlocal_multiplayer.show()
		hlocal_multiplayer.only_show_lmnodes(["back","joinserver","createserver"])
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hlocal_multiplayer = local_multiplayer_scene.instantiate()
		hlocal_multiplayer.lm_exit.connect(_handle_lm_exit)
		hlocal_multiplayer.lm_find_server.connect(_discover_local_servers_setup)
		hlocal_multiplayer.lm_create_server.connect(_start_local_server)
		hlocal_multiplayer.lm_join_server.connect(_start_local_client)
		#set up connections
		
		add_child(hlocal_multiplayer)		

func _handle_lm_exit(val)->void:
	match val:
		"hard":
			unload_scene(hlocal_multiplayer)
			load_main_menu()
			is_local = false
		"windup":
			lm_windup()		

func _start_local_server(arg_server_params:Dictionary)->void:
	port =arg_server_params['port']
	lobby_name=arg_server_params['lobby_name']
	hlocal_multiplayer.hlm_nodes['port'].text="hello"
	#validate

		#for interface in IP.get_local_interfaces():
			#if interface["friendly"] == "Wi-Fi":
				#address = interface["addresses"][-1]
		#
	udp_server_socket = PacketPeerUDP.new()
	udp_server_socket.set_broadcast_enabled(true)
	udp_server_socket.set_dest_address("255.255.255.255", DEFAULT_CLIENT_PORT)
	
	discovery_ping()

func discovery_ping()->void:
	if is_instance_valid(udp_server_socket):
		udp_server_socket.put_packet(str("Mixorcerers|0.1.0|",port,"|",lobby_name).to_ascii_buffer())
		get_tree().create_timer(1.).timeout.connect(discovery_ping)
	
func discover_local_servers(timeout:int = 0,local_servers:=[])->void:
	if is_instance_valid(udp_client_socket):
		var packet_count = udp_client_socket.get_available_packet_count()
		if  packet_count > 0:
			for i in range(packet_count):
				var data = udp_client_socket.get_packet().get_string_from_ascii().split('|',false)
				var address = udp_client_socket.get_packet_ip()
				if data[0] == 'Mixorcerers':
					match data[1]:
						"0.1.0":
							if data.size() == 4:
								var unsafe_port = int(data[2]) if data[2].is_valid_int() else -1
								if unsafe_port>49152 and unsafe_port < 65535:
									var server = {'address':address,'port':unsafe_port,"lobby_name":data[3]}
									if server not in local_servers:
										local_servers.append(server)
										hlocal_multiplayer.display_local_servers(local_servers)
		else:
			hlocal_multiplayer.display_local_servers([])
		get_tree().create_timer(1.).timeout.connect(discover_local_servers.bind(0 if timeout>2 else timeout+1,[] if timeout>2 else local_servers))

func _start_local_client(arg):
	print(arg)
	var peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_client(arg['address'],arg['port'])
	if err:
		return err
	multiplayer.multiplayer_peer = peer

func _discover_local_servers_setup()->void:
	udp_client_socket = PacketPeerUDP.new()
	udp_client_socket.bind(DEFAULT_CLIENT_PORT)
	discover_local_servers()
	





func _on_client_connected(id:int)->void:
	print(id)
	
func _on_client_disconnected(id:int)->void:
	print(id)

func _on_server_connected_ok()->void:
	pass


func _on_server_connected_fail()->void:
	print ("fail")

func _on_server_disconnected()->void:
	pass

func lm_windup()->void:
	udp_server_socket = null
	udp_client_socket = null
	multiplayer.multiplayer_peer = null
	
