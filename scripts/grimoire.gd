class_name Grimoire
extends Node


var spell:Spell
var type:Grimoire_Type
var value:int
enum Grimoire_Type{
	NONE,
	ON_DMG,
	On_TERRAIN_CHANGE
}
func _ready():
	pass

func _process(_delta):
	pass

func _init(arg_spell:Spell,arg_type:Grimoire_Type,arg_value):
	spell =arg_spell
	type=arg_type
	value =arg_value
