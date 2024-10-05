class_name Display
extends Node2D

var alias:String
var game :Game
var map :Map 
var cursor :Cursor
var hud: HUD
var update = true
var props:Array

func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	game = arg_game
	map = arg_map
	cursor = arg_cursor
	hud = arg_hud
	props = arg_props.duplicate()
	#this goddamn lack of duplicate cost me 1 hour.	
	game.mode.append(self)
	game.add_child(self)

func windup():
	game.mode.erase(self)
	self.queue_free()
