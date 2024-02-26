extends Node2D

var Game
var Map
var Cursor
var HUD
var freeze_process = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not freeze_process:
		if Cursor.get_overlapping_areas():
			freeze_process = true
			HUD.command_display(Cursor.get_overlapping_areas(),self)
		else:
			Game.mode.pop_back()
			queue_free()
	if Input.is_action_just_pressed("cancel_action"):
		HUD.clear_command_display()
		Game.mode.erase(self)
		self.queue_free()
		

func setup(game,map,cursor,hud):
	Game = game
	Map = map
	Cursor = cursor
	HUD = hud

func _on_button_message(val):
	HUD.clear_command_display()
	var selected_base_mode = Game.base_mode_scene.instantiate()
	selected_base_mode.setup(Game,Map,Cursor,HUD,val)
	Game.mode.push_back(selected_base_mode)
	Game.add_child(selected_base_mode)
	print(Game.mode)
	Game.mode.erase(self)
	print(Game.mode)
	self.queue_free()
	
	print(val)
