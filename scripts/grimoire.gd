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

func _init(arg_spell:Spell,arg_type:String,arg_value:int):
	spell =arg_spell
	for x in Grimoire_Type:
		if Grimoire_Type[x] == arg_type:
			type = x
	value =arg_value
