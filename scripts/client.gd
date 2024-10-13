extends Control

var main_menu_scene:PackedScene
var main_menu_handle

var game_scene:PackedScene
var game_handle
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

func load_scene(scene_type:Scenes):
	match scene_type:
		Scenes.MAIN_MENU:
			set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT,Control.PRESET_MODE_KEEP_SIZE)
			main_menu_handle = main_menu_scene.instantiate()
			main_menu_handle.get_node("LaunchGameDebug").pressed.connect(_on_launchgame_pressed)
			add_child(main_menu_handle)
		Scenes.GAME:
			set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT,Control.PRESET_MODE_KEEP_SIZE)
			game_handle = game_scene.instantiate()
			add_child(game_handle)


func _on_launchgame_pressed():
	main_menu_handle.hide()
	load_scene(Scenes.GAME)
