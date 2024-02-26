extends Node2D

var Game
var Map
var Cursor
var HUD
var freeze_process = false
var entity
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not freeze_process and entity:
		freeze_process= true
		HUD.command_display(entity.commands,self)

func setup(game,map,cursor,hud,selected):
	Game = game
	Map = map
	Cursor = cursor
	HUD = hud
	entity = selected

func _on_button_message(val):
	print(val)
