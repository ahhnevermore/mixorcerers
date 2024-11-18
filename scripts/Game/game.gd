class_name Game
extends Node

var replay :bool = false
var mode :Array =[]

var mix_display_scene:PackedScene
var precast_display_scene:PackedScene

var turn_history:Array
var listeners:Array

var player#p1,p2
var enemy
#signal damage_trigger
#signal terrain_trigger
func setup(arg_player):
	player = arg_player
	if player == 'p1':
		enemy ='p2'
	else:
		enemy='p1'	
func _ready():
	mix_display_scene = load("res://scenes/Game/States/mix_display.tscn")
	precast_display_scene=load("res://scenes/Game/States/precast_display.tscn")
	

	$Map.gen_map()
	$Player.gen_visible_tiles()
	$Player.display_vision([])
	#$Player1.display_move_grid()
	_on_cursor_changed()
#
#	print(IP.get_local_interfaces())
#	var nums = [1,2,3,4]
#	for num in nums:
#		if nums[-1] < 10:
#			nums.append(nums[-1]+1)
#		print(num)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not mode and Input.is_action_just_pressed("select_confirm"):
		add_child(SelectMode.new(self,$Map,$Cursor,$HUD,[]))



	

#TODO
#camera zoom in and out
#add hotkeys
#persistent effects,check for burn etc when moving - dependent on good UI so I can show effects
#add spell stats when selecting them in cast mode
#Spells - various dmg distributions, various spells,various casts
#add sprites for spells
#add sound effects for spells and tiles
# mod sprites for terrain
#create a game moves data structure, then make the enemy perform its moves
#write turns to file
#turn transition

#COMPLETED

#decide regarding spell speeds-remains same
#Spell- Blink
#Path finding algorithm and movement - Completed
#vision - done
#add spell prop to dict-not sure what it means but done
#add enemy
#loading maps from filea
#camera
#mix mode- additional cost
#			replacing spells and refunding costs
#precasting grimoires
#modify cast spell to not apply damage but instead sublet it to the listeners



# all the user content in user://
# after about 10 recursive depth, program has noticeable lag
#All terrain modifications have to set the cache of the terrain to null

func _on_cursor_changed()->void:
	$HUD.terrain_display($Map.get_terrain($Map.get_tile($Cursor.cursor_tile)),$Cursor.cursor_tile)

var spells = {
	"fireball":{
		'alias':"fireball",'sprite':"res://icon.svg",
		'cast_range':5,'cast_shape':Spell.cast_shapes.CIRCLE,'cast_dim':[1],
		'fire_dmg':10.0,'water_dmg':0.0,'earth_dmg':0.0,'air_dmg':0.0, 'dmg_dist':Spell.DMG_Distribution.CLEAN,
		'gen_unit':false,'gen_artifact':false,
		'terrain_mod':[0,-1],
		'magycke_mod':[['dmg',{'fire':5,'water':0,'earth':0,'air':0}],['burn',{'duration':2,'dmg':5}]],
		'day_mod':[[]],'night_mod':[[]],
		'modifiers':[['vision',{'duration':2}]],
		'repeat_cost':{'fire':1,'water':0,'earth':0,'air':0},
		'grimoire_cost':{'fire':1,'water':0,'earth':0,'air':0}},
	"blink":{
		'alias':"blink",'sprite':"",
		'cast_range':3,'cast_shape':Spell.cast_shapes.CIRCLE,'cast_dim':[0],
		'fire_dmg':0.0,'water_dmg':0.0,'earth_dmg':0.0,'air_dmg':0.0, 'dmg_dist':Spell.DMG_Distribution.CLEAN,
		'gen_unit':false,'gen_artifact':false,
		'terrain_mod':[],
		'magycke_mod':[['dmg',{'fire':1,'water':0,'earth':0,'air':1}],['cast_dim',[1]]],
		'day_mod':[[]],'night_mod':[[]],
		'modifiers':[['move',{}]],
		'repeat_cost':{'fire':1,'water':0,'earth':0,'air':1},
		'grimoire_cost':{'fire':0,'water':1,'earth':0,'air':0}
	}
}

var recipes= {
	{'fire':3,'water':0,'earth':0,'air':0 }: 'fireball',
	{'fire':1,'water':1,'earth':0,'air':1 }: 'blink',
}
