class_name Grimoire
extends Node

var castable= true
var alias
var spell:Spell
var type:Grimoire_Type
var value
var precast_position
var id
var remote_id
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

func _init(arg_spell:Spell,arg_type:Grimoire_Type,arg_value,arg_rid:=-1):
	spell =arg_spell
	type=arg_type
	value =arg_value
	alias = spell.alias + "*"
	id= Game.get_id()
	remote_id = arg_rid
func windup():
	spell.queue_free()
	queue_free()
