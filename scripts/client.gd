extends Control

var main_menu_scene:PackedScene
var hmain_menu

var game_scene:PackedScene
var hgame
enum Scenes{
	MAIN_MENU,
	GAME
}

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_scene = load("res://scenes/main_menu.tscn")
	game_scene = load("res://scenes/Game/game.tscn")
	
	load_scene(Scenes.MAIN_MENU)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unload_scene(hscene:Node,hard=false):
	if hard:
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
				add_child(hmain_menu)
		Scenes.GAME:
			if hgame:
				hgame.show()
			else:
				set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)
				hgame = game_scene.instantiate()
				add_child(hgame)


func _on_launchgame_pressed():
	unload_scene(hmain_menu)
	load_scene(Scenes.GAME)
