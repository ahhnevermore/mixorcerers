class_name Spell
extends Area2D

#programmatic properties
var castable = true
var alias:String
var sprite:Texture2D

#casting
var cast_range:int
var cast_shape:cast_shapes
var cast_dim:Array

#damage
var fire_dmg:float
var water_dmg:float
var earth_dmg:float
var air_dmg:float
var dmg_dist:DMG_Distribution

#other properties
var gen_unit
var gen_artifact

#terrain modifications
var elevation_mod:int
var moisture_mod :int

#specific buffs got from the magyckes
var magycke_mod:Array
var day_mod:Array
var night_mod:Array

var modifiers :Array #general purpose array that is primarily used for day night effect or texture surprise
					#also has "provides vision traits
					#every modifier will be a 2d array,[name,{props}]
#additional costs
var repeat_cost:Dictionary
var grimoire_cost:Dictionary
var real_cost:Dictionary


enum cast_shapes{
	STRAIGHT_LINE,
	CIRCLE,
	GRENADE,
	VECTOR
}

enum DMG_Distribution{
	CLEAN,
	SHOTGUN
	
}#different ways to distribute damage across the cast grid
func _init(config:Dictionary,arg_modifiers:Array,arg_real_cost:Dictionary):
	alias= config['alias']
	sprite  = load(config['sprite'])
	
	cast_range = config['cast_range']
	cast_shape = config['cast_shape']
	cast_dim = config['cast_dim'].duplicate()
	
	fire_dmg = config['fire_dmg']
	water_dmg = config['water_dmg']
	earth_dmg = config['earth_dmg']
	air_dmg = config['air_dmg']
	dmg_dist = config['dmg_dist']
	
	gen_unit = config['gen_unit']
	gen_artifact =config['gen_artifact']
	
	elevation_mod = config['elevation_mod']
	moisture_mod = config['moisture_mod']
	
	magycke_mod = config['magycke_mod'].duplicate()
	day_mod=config['day_mod'].duplicate()
	night_mod=config['night_mod'].duplicate()

	modifiers.append_array(arg_modifiers)
	modifiers.append_array(config['modifiers'])
	
	repeat_cost=config['repeat_cost'].duplicate()
	grimoire_cost=config['grimoire_cost'].duplicate()
	real_cost = arg_real_cost.duplicate()
	
	var res =[]
	for mod in modifiers:
		if mod is String:
			var xs
			match mod.to_lower():
				'magycke':
					xs = magycke_mod
				'day':
					xs = day_mod
				'night':
					xs = night_mod
			for x in xs:
				if x.size()>0:
					if x[0] == 'dmg':
						fire_dmg += x[1]['fire']
						water_dmg += x[1]['water']
						earth_dmg += x[1]['earth']
						air_dmg += x[1]['air']
					else:
						res.append(x)
		else: 
			res.append(mod)
	modifiers= res.duplicate(true)
	
