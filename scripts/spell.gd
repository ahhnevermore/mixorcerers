class_name Spell
extends Area2D

var castable = true
var alias:String
var cast_range:int
var cast_shape:cast_shapes
var cast_dim:Array
var fire_dmg:float
var water_dmg:float
var earth_dmg:float
var air_dmg:float
var sprite:Texture2D
var gen_unit
var gen_item
var grimoire:bool
var elevation_mod
var moisture_mod
var modifier :Array #general purpose array that is primarily used for day night effect or texture surprise
					#also has "provides vision traits
enum cast_shapes{
	STRAIGHT_LINE,
	CIRCLE,
	GRENADE,
	VECTOR
}

func _init(config:Dictionary,arg_modifier:Array,arg_grimoire:bool =false):
	alias= config['alias']
	cast_range = config['cast_range']
	cast_shape = config['cast_shape']
	cast_dim = config['cast_dim']
	fire_dmg = config['fire_dmg']
	water_dmg = config['water_dmg']
	earth_dmg = config['earth_dmg']
	air_dmg = config['air_dmg']
	sprite  = load(config['sprite'])
	gen_unit = config['gen_unit']
	gen_item =config['gen_item']
	elevation_mod = config['elevation_mod']
	moisture_mod = config['moisture_mod']
	grimoire = arg_grimoire
	modifier.append_array(arg_modifier)
	modifier.append_array(config['modifier'])
