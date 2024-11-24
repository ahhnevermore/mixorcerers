class_name Mode
extends Node

var alias:String
var game:Game
var map
var cursor
var hud
var update = true
var props:Array

func _init(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	game = arg_game
	map = arg_map
	cursor = arg_cursor
	hud = arg_hud
	props = arg_props.duplicate()
	#this goddamn lack of duplicate cost me 1 hour.	
	game.mode.append(self)
	
func windup()->void:
	game.mode.erase(self)
	self.queue_free()
