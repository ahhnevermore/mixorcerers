extends Node2D

var Game
var Map
var Cursor
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Cursor.get_overlapping_areas():
		print("proceed further")
	else:
		Game.mode.pop_back()
		print(Game.mode)
		queue_free()

func setup(game,map,cursor):
	Game = game
	Map = map
	Cursor = cursor
	
