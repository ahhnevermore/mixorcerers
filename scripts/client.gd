extends Control

func _on_local_server_message(message):
	match message[0]:
		"hello":
			if is_instance_valid(hlm_nodes['port']):
				hlm_nodes['port'].text = message[0]
func unload_scene(hscene:Node,hard=false):
	if hard:
		remove_child(hscene)
	else:
		hscene.hide()

func _ready():
	main_menu_scene = load("res://scenes/main_menu.tscn")
	game_scene = load("res://scenes/Game/game.tscn")
	local_multiplayer_scene = load("res://scenes/local_multiplayer.tscn")
	lobby_scene = load("res://scenes/lobby.tscn")
	
	load_main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#MAIN MENU
var main_menu_scene:PackedScene
var hmain_menu

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
	
#-------------------
#LOCAL MULTIPLAYER
var hlocal_server

var local_multiplayer_scene:PackedScene
var hlocal_multiplayer
var hlm_nodes:Dictionary
# back hBackButton		join hJoinServerButton		list hServerList		port hPort		create hCreateServerButton
var unsafe_text:String

func load_local_multiplayer():
	if is_instance_valid( hlocal_multiplayer):
		hlocal_multiplayer.show()
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hlocal_multiplayer = local_multiplayer_scene.instantiate()
		
		#set up connections
		var i = 0
		var arr = hlocal_multiplayer.get_children()
		for node in ["back","join","list","port","create"]:
			hlm_nodes[node]=arr[i]
			i += 1
			
		hlm_nodes["back"].pressed.connect(_on_backbuttonlm_pressed)
		hlm_nodes["join"].pressed.connect(_on_joinserver_pressed)
		hlm_nodes["port"].text_changed.connect(_on_port_text_changed)
		hlm_nodes["create"].pressed.connect(_on_createserver_pressed)
		
		add_child(hlocal_multiplayer)		

func _on_backbuttonlm_pressed():
	unload_scene(hlocal_multiplayer)
	load_main_menu()

func _on_backbuttonlmjoincreate_pressed():
	hlm_nodes["back"].pressed.disconnect(_on_backbuttonlmjoincreate_pressed)
	hlm_nodes["back"].pressed.connect(_on_backbuttonlm_pressed)
	
	hlm_nodes["join"].show()
	hlm_nodes["port"].show()
	hlm_nodes["create"].show()
	hlm_nodes["list"].hide()
	
func _on_joinserver_pressed():
	hlm_nodes["back"].pressed.disconnect(_on_backbuttonlm_pressed)
	hlm_nodes["back"].pressed.connect(_on_backbuttonlmjoincreate_pressed)

	hlm_nodes['create'].hide()
	hlm_nodes['port'].hide()
	
func _on_createserver_pressed():
	#hlm_nodes["back"].pressed.disconnect(_on_backbuttonlm_pressed)
	#hlm_nodes["back"].pressed.connect(_on_backbuttonlmjoincreate_pressed)

	var port = int(unsafe_text) if unsafe_text.is_valid_int() else 49500
	if port<49152 or port > 65535:
		hlm_nodes['port'].text = "Invalid Port"
	
	hlocal_server = LocalServer.new(port)
	hlocal_server.localserver_message.connect(_on_local_server_message)
	add_child(hlocal_server)
	
		

func _on_port_text_changed(new_text:String):
	unsafe_text = new_text
#----------------
#LOBBY
var lobby_scene:PackedScene
var hlobby


func load_lobby():
	if is_instance_valid(hlobby):
		hlobby.show()
	else:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
		hlobby = lobby_scene.instantiate()
		hlobby.get_node("StartGameButton").pressed.connect(_on_startgame_pressed)
		
		add_child(hlobby)
func _on_startgame_pressed():
	load_game()

#------------------
#GAME
var game_scene:PackedScene
var hgame

func load_game():
	if is_instance_valid(hgame):
			hgame.show()
	else:
		load_lobby()
		for child in hlobby.get_children():
			child.queue_free()
		set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)

		hgame = game_scene.instantiate()
		hlobby.add_child(hgame)
