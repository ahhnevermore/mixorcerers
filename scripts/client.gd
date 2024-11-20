class_name Client
extends Control


var players :=[]
var is_local:=false
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
	
	#TODO may have to use these signals to handle wifi disconnects etc later
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_server_connected_ok)
	multiplayer.connection_failed.connect(_on_server_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	multiplayer.multiplayer_peer = null

	load_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass
#------------------------------------------------
#MAIN MENU
var main_menu_scene:PackedScene
var hmain_menu:Control


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
		hgame.turn.connect(hgame.get_node("Map")._on_game_turn)
		hgame.turn.connect(hgame.get_node("HUD")._on_game_turn)
		hgame.setup("p1" if players.size()==0 or multiplayer.get_unique_id() == players[0]['id'] else "p2")
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
		hlocal_multiplayer.lm_join_server.connect(_start_client)
		hlocal_multiplayer.lm_start_game.connect(_start_local_game.rpc)
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

func _start_local_server(arg_server_params:Dictionary):
	if not udp_server_socket:
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
		
		var peer = ENetMultiplayerPeer.new()
		var err = peer.create_server(port)
		if err:
			return err
		multiplayer.multiplayer_peer = peer	
		players.append(get_client_info())
		hlocal_multiplayer.only_show_lmnodes(["playerlist","back","startgame"])
		hlocal_multiplayer.display_players(players) 
		print("local server created")
		discovery_ping()
		is_local = true

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


func _discover_local_servers_setup()->void:
	if not udp_client_socket:
		udp_client_socket = PacketPeerUDP.new()
		var error = udp_client_socket.bind(DEFAULT_CLIENT_PORT)
		if error:
			print("discover local failed")
			hlocal_multiplayer._back_joincreate_lmmain()
		else:	
			discover_local_servers()
			is_local = true
		


func _start_client(arg):
	if not multiplayer.multiplayer_peer:
		var peer = ENetMultiplayerPeer.new()
		var err = peer.create_client(arg['address'],arg['port'])
		if err:
			return err
		multiplayer.multiplayer_peer = peer
		print("local client created")

@rpc("call_local","authority",'reliable')
func _start_local_game():
	if players.size()>=2:
		unload_scene(hlocal_multiplayer,true)	
		load_game()
#This approach will have to work
#Client connected and register player work in an odd way. First every peer gets a signal of the new peer id. 
#each peer then sends its own info and calls register player on the new peer n times. 
#every client registers itself with itself on connecting first


#func _on_client_connected(id:int)->void:
	#_register_player.rpc_id(id, {'name':'Client'})
#
@rpc("any_peer", "reliable")
func rem_register_player(new_player_info):
	players.append(new_player_info)
	for player in players:
		sync_data.rpc(players,"players")
	if is_local:
		hlocal_multiplayer.display_players(players)
	
@rpc("any_peer","reliable","call_remote")
func sync_data(data,meta):
	match meta:
		"players":
			players = data
			if is_local:
				hlocal_multiplayer.display_players(players)
func _on_peer_connected(_id):
	pass
			
		
func _on_peer_disconnected(id:int)->void:
	var index
	for i in range(players.size()):
		if players[i]['id'] == id:
			index = i
	players.remove_at(index)
	if is_local:
		hlocal_multiplayer.display_players(players)


func _on_server_connected_fail()->void:
	print ("fail")
	lm_windup()

func _on_server_disconnected()->void:
	hlocal_multiplayer._back_joincreate_lmmain()
	lm_windup()

func _on_server_connected_ok():
	rem_register_player.rpc_id(1,get_client_info())
	if is_local:
		hlocal_multiplayer.only_show_lmnodes(["playerlist","back"])
		hlocal_multiplayer.display_players(players) 
	print("client connected")

func get_client_info():
	if multiplayer.is_server():
		return {'player_name':'Server','id':1}
	else:
		return {'player_name':'Client','id':multiplayer.get_unique_id()}


func lm_windup()->void:
	udp_server_socket = null
	udp_client_socket = null
	multiplayer.multiplayer_peer = null
	players.clear()
	is_local= false
	
