extends Control
var unsafe_port_text:String=''
var unsafe_lobbyname_text:String = 'Test Lobby'
var hlm_nodes:Dictionary

signal lm_exit
signal lm_client
signal lm_server
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	var arr = get_children()
	for node in ["back","lobbyname","port","createserver","joinserver","serverlist","playerlist","startgame"]:
		hlm_nodes[node]=arr[i]
		i += 1
		
	hlm_nodes["back"].pressed.connect(_back_lmmain_mainmenu)
	hlm_nodes["joinserver"].pressed.connect(_on_joinserver_pressed)
	hlm_nodes["port"].text_changed.connect(_on_port_text_changed)
	hlm_nodes["createserver"].pressed.connect(_createserver_screen)
	
	only_show_lmnodes(["back","joinserver","createserver"])
		


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
	lm_exit.emit()


func _on_joinserver_pressed():
	hlm_nodes["back"].pressed.disconnect(_back_lmmain_mainmenu)
	hlm_nodes["back"].pressed.connect(_back_joincreate_lmmain)
	
	only_show_lmnodes(["joinserver","back","serverlist"])
	lm_client.emit()
	
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
	
	only_show_lmnodes(["back","joinserver","createserver"])
	
		
		
func _on_createserver_pressed():
	#hlm_nodes["back"].pressed.disconnect(_on_backbuttonlm_pressed)
	#hlm_nodes["back"].pressed.connect(_on_backbuttonlmjoincreate_pressed)
	
	var port = int(unsafe_port_text) if unsafe_port_text.is_valid_int() else 49500
	if port<49152 or port > 65535:
		hlm_nodes['port'].text = "Invalid Port"
	else:
		lm_server.emit({"port":port,"lobby_name":unsafe_lobbyname_text})

func _on_port_text_changed(new_text:String):
	unsafe_port_text = new_text
