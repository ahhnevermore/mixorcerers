extends Control

func _on_local_server_message(message):
	match message[0]:
		"hello":
			if is_instance_valid(hlm_nodes['createserver']):
				hlm_nodes['createserver'].get_node('Port').text = message[0]
func unload_scene(hscene:Node,hard=false):
	if hard:
		remove_child(hscene)
	else:
		hscene.hide()

func _ready():
	main_menu_scene = load("res://scenes/main_menu.tscn")
	game_scene = load("res://scenes/Game/game.tscn")
	local_multiplayer_scene = load("res://scenes/local_multiplayer.tscn")

	
	load_main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#MAIN MENU
var main_menu_scene:PackedScene
var hmain_menu
var is_local:bool

func load_main_menu():
	if is_instance_valid(hmain_menu):
				hmain_menu.show()
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hmain_menu = main_menu_scene.instantiate()
		
		hmain_menu.get_node("LaunchGameDebug").pressed.connect(_on_launchgame_pressed)
		hmain_menu.get_node("LocalMultiplayer").pressed.connect(_on_local_multiplayer_pressed)
		
		add_child(hmain_menu)

func _on_launchgame_pressed():
	unload_scene(hmain_menu)
	load_game()

func _on_local_multiplayer_pressed():
	unload_scene(hmain_menu)
	load_local_multiplayer()
	is_local = true
	
#-------------------
#LOCAL MULTIPLAYER
var hlocal_server

var local_multiplayer_scene:PackedScene
var hlocal_multiplayer
var hlm_nodes:Dictionary
var hlobby
# back hBackButton		join hJoinServerButton		list hServerList		port hPort		create hCreateServerButton
var unsafe_text:String

func load_local_multiplayer():
	if is_instance_valid( hlocal_multiplayer):
		hlocal_multiplayer.show()
		only_show_lmnodes(["back","joinserver","createserver"])
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hlocal_multiplayer = local_multiplayer_scene.instantiate()
		
		#set up connections
		var i = 0
		var arr = hlocal_multiplayer.get_children()
		for node in ["back","lobbyname","port","createserver","joinserver","serverlist","playerlist","startgame"]:
			hlm_nodes[node]=arr[i]
			i += 1
			
		hlm_nodes["back"].pressed.connect(_back_lmmain_mainmenu)
		hlm_nodes["joinserver"].pressed.connect(_on_joinserver_pressed)
		hlm_nodes["port"].text_changed.connect(_on_port_text_changed)
		hlm_nodes["createserver"].pressed.connect(_createserver_screen)
		
		only_show_lmnodes(["back","joinserver","createserver"])
		
		add_child(hlocal_multiplayer)		

func only_show_lmnodes(xs:Array):
	for node in hlm_nodes:
			if node in xs:
				hlm_nodes[node].show()
			else:
				hlm_nodes[node].hide()
				
func _back_lmmain_mainmenu():
	unload_scene(hlocal_multiplayer)
	load_main_menu()


func _on_joinserver_pressed():
	hlm_nodes["back"].pressed.disconnect(_back_lmmain_mainmenu)
	hlm_nodes["back"].pressed.connect(_back_joincreate_lmmain)

	only_show_lmnodes(["joinserver","back","serverlist"])
	
func _createserver_screen():
	hlm_nodes["createserver"].pressed.disconnect(_createserver_screen)
	hlm_nodes["createserver"].pressed.connect(_on_createserver_pressed)
	
	hlm_nodes["back"].pressed.disconnect(_back_lmmain_mainmenu)
	hlm_nodes["back"].pressed.connect(_back_joincreate_lmmain)
	
	only_show_lmnodes(["port","lobbyname","createserver","back"])


func _back_joincreate_lmmain():
	hlm_nodes["back"].pressed.disconnect(_back_joincreate_lmmain)
	hlm_nodes["back"].pressed.connect(_back_lmmain_mainmenu)
	
	load_local_multiplayer()
	
		
		
func _on_createserver_pressed():
	#hlm_nodes["back"].pressed.disconnect(_on_backbuttonlm_pressed)
	#hlm_nodes["back"].pressed.connect(_on_backbuttonlmjoincreate_pressed)
	
	var port = int(unsafe_text) if unsafe_text.is_valid_int() else 49500
	if port<49152 or port > 65535:
		hlm_nodes['port'].text = "Invalid Port"
	elif not is_instance_valid(hlocal_server):
		hlocal_server = LocalServer.new(port)
		hlocal_server.localserver_message.connect(_on_local_server_message)
		add_child(hlocal_server)
	
		

func _on_port_text_changed(new_text:String):
	unsafe_text = new_text






#------------------
#GAME
var game_scene:PackedScene
var hgame

func load_game():
	if is_instance_valid(hgame):
			hgame.show()
	else:
		if not is_instance_valid(hlobby):
			hlobby = Lobby.new(is_local)
			add_child(hlobby)
		set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)
		hgame = game_scene.instantiate()
		hlobby.add_child(hgame)
