extends Control

var main_menu_scene:PackedScene
var hmain_menu

var game_scene:PackedScene
var hgame


var local_multiplayer_scene:PackedScene
var hlocal_multiplayer

var hJoinServerButton
var hPort
var hCreateServerButton
var unsafe_text



enum Scenes{
	MAIN_MENU,
	GAME,
	LOCAL_MULTIPLAYER
}

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_scene = load("res://scenes/main_menu.tscn")
	game_scene = load("res://scenes/Game/game.tscn")
	local_multiplayer_scene = load("res://scenes/local_multiplayer.tscn")
	
	load_scene(Scenes.MAIN_MENU)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func unload_scene(hscene:Node,hard=false):
	if hard:
		match hscene:
			hgame:
				pass
			hmain_menu:
				pass
			hlocal_multiplayer:
				hCreateServerButton =  null
				hJoinServerButton = null
				hPort = null
				
		remove_child(hscene)
	else:
		hscene.hide()
		
func load_scene(scene_type:Scenes):
	match scene_type:
		Scenes.MAIN_MENU:
			if hmain_menu:
				hmain_menu.show()
			else:
				set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
				hmain_menu = main_menu_scene.instantiate()
				
				hmain_menu.get_node("LaunchGameDebug").pressed.connect(_on_launchgame_pressed)
				hmain_menu.get_node("LocalMultiplayer").pressed.connect(_on_local_multiplayer_pressed)
				
				add_child(hmain_menu)
		Scenes.GAME:
			if hgame:
				hgame.show()
			else:
				set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)
				hgame = game_scene.instantiate()
				add_child(hgame)
		Scenes.LOCAL_MULTIPLAYER:
			if hlocal_multiplayer:
				hlocal_multiplayer.show()
			else:
				set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
				hlocal_multiplayer = local_multiplayer_scene.instantiate()
				
				hJoinServerButton = hlocal_multiplayer.get_node("JoinServerButton")
				hJoinServerButton.pressed.connect(_on_joinserver_pressed)
				hCreateServerButton = hlocal_multiplayer.get_node("CreateServerButton")
				hCreateServerButton.pressed.connect(_on_createserver_pressed)
				hPort = hlocal_multiplayer.get_node("Port")
				hPort.text_changed.connect(_on_port_text_changed)
				
				add_child(hlocal_multiplayer)

func _on_launchgame_pressed():
	unload_scene(hmain_menu)
	load_scene(Scenes.GAME)

func _on_local_multiplayer_pressed():
	unload_scene(hmain_menu)
	load_scene(Scenes.LOCAL_MULTIPLAYER)
	
func _on_joinserver_pressed():
	hCreateServerButton.hide()
	hPort.hide()

func _on_createserver_pressed():
	pass

func _on_port_text_changed(new_text:String):
	pass
