extends Control
var unsafe_port_text:String=''
var unsafe_lobbyname_text:String = 'Test Lobby'
var hlm_nodes:Dictionary

signal lm_exit
signal lm_find_server
signal lm_create_server
signal lm_join_server
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	var arr = get_children()
	for node in ["back","lobbyname","port","createserver","findserver","serverlist","playerlist","startgame"]:
		hlm_nodes[node]=arr[i]
		i += 1
		
	hlm_nodes["back"].pressed.connect(_back_lmmain_mainmenu)
	hlm_nodes["findserver"].pressed.connect(_on_findserver_pressed)
	hlm_nodes["port"].text_changed.connect(_on_port_text_changed)
	hlm_nodes["createserver"].pressed.connect(_createserver_screen)
	
	only_show_lmnodes(["back","findserver","createserver"])
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func only_show_lmnodes(xs:Array):
	for node in hlm_nodes:
			if node in xs:
				hlm_nodes[node].show()
			else:
				hlm_nodes[node].hide()
func _back_lmmain_mainmenu():
	lm_exit.emit("hard")


func _on_findserver_pressed():
	hlm_nodes["back"].pressed.disconnect(_back_lmmain_mainmenu)
	hlm_nodes["back"].pressed.connect(_back_joincreate_lmmain)
	
	only_show_lmnodes(["findserver","back","serverlist"])
	lm_find_server.emit()
	
func _createserver_screen():
	hlm_nodes["createserver"].pressed.disconnect(_createserver_screen)
	hlm_nodes["createserver"].pressed.connect(_on_createserver_pressed)
	
	hlm_nodes["back"].pressed.disconnect(_back_lmmain_mainmenu)
	hlm_nodes["back"].pressed.connect(_back_joincreate_lmmain)
	
	only_show_lmnodes(["port","lobbyname","createserver","back"])
	hlm_nodes['port'].text =''
	hlm_nodes['lobbyname'].text =''


func _back_joincreate_lmmain():
	hlm_nodes["back"].pressed.disconnect(_back_joincreate_lmmain)
	hlm_nodes["back"].pressed.connect(_back_lmmain_mainmenu)
	
	hlm_nodes["createserver"].pressed.disconnect(_on_createserver_pressed)
	hlm_nodes["createserver"].pressed.connect(_createserver_screen)
	
	only_show_lmnodes(["back","findserver","createserver"])
	lm_exit.emit("windup")
	
		
		
func _on_createserver_pressed():
	#hlm_nodes["back"].pressed.disconnect(_on_backbuttonlm_pressed)
	#hlm_nodes["back"].pressed.connect(_on_backbuttonlmjoincreate_pressed)
	
	var port = int(unsafe_port_text) if unsafe_port_text.is_valid_int() else 49500
	if port<49152 or port > 65535:
		hlm_nodes['port'].text = "Invalid Port"
	else:
		lm_create_server.emit({"port":port,"lobby_name":unsafe_lobbyname_text})

func _on_port_text_changed(new_text:String):
	unsafe_port_text = new_text

func display_local_servers(xs:Array):
	for x in xs:
		var button = Button.new()
		button.text = x['lobby_name']
		button.set_meta("server_id",x.hash())
		button.pressed.connect(_on_joinserver_pressed.bind(button.get_meta("server_id")))
		hlm_nodes["serverlist"].add_child(button)

func _on_joinserver_pressed(arg):
	lm_join_server.emit(arg)
