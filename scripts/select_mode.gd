extends Node2D

var Game
var Map
var Cursor
var HUD
var freeze_process = false
var selected
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not freeze_process:
		if Cursor.get_overlapping_areas():
			freeze_process = true
			HUD.select_display(Cursor.get_overlapping_areas(),self)
		else:
			Game.mode.pop_back()
			print(Game.mode)
			queue_free()

func setup(game,map,cursor,hud):
	Game = game
	Map = map
	Cursor = cursor
	HUD = hud

func _on_button_message(val):
	selected = val
	print(selected)
