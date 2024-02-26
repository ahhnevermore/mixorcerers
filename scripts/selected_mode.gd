extends Node2D

var Game
var Map
var Cursor
var HUD
var freeze_process = false
var selected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(game,map,cursor,hud,selected):
	Game = game
	Map = map
	Cursor = cursor
	HUD = hud
	self.selected = selected
	print(self.selected)
