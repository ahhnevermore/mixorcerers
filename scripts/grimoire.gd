class_name Grimoire
extends Node

var castable= true
var alias
var spell:Spell
var type:Grimoire_Type
var value
var precast_cursor
var precast_position
enum Grimoire_Type{
	NONE,
	ON_DMG,
	ON_TERRAIN_CHANGE
}

enum Precast_Position_Type{
	RELATIVE,
	ABSOLUTE
}
func _ready():
	pass

func _process(_delta):
	pass

func _init(arg_spell:Spell,arg_type:Grimoire_Type,arg_value):
	spell =arg_spell
	type=arg_type
	value =arg_value
	alias = spell.alias + "*"
