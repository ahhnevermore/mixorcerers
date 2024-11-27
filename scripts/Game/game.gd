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

var is_myturn

static var id_gen = -1
signal turn
#signal damage_trigger
#signal terrain_trigger

static func get_id():
	id_gen +=1
	return id_gen
	
func setup(arg_player):
	
	player = arg_player
	if player == 'p1':
		enemy ='p2'
		is_myturn = true
	else:
		enemy='p1'	
		is_myturn = false
		

func _ready():
	mix_display_scene = load("res://scenes/Game/States/mix_display.tscn")
	precast_display_scene=load("res://scenes/Game/States/precast_display.tscn")
	
	turn.emit(0,is_myturn)
	$Map.gen_map()
	$Player.gen_visible_tiles()
	$Player.display_vision([])
	#$Player1.display_move_grid()
	_on_cursor_changed()
	
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

#what is an action.there can only be 3 - movement. creation. destruction. everything else can be resolved
#move		create		precast		cast	remove
#precast actions of an object delete the previous precast action to that object
#top level action field 
# id	Caster	action-desc		object		cursor_pos		top-level
#CAUTION cycling spell could lead to overballooning turn history
#CAUTION currently precasting in the same turn as creating the grimoire doesnt actually do all that much,because the object
#is serialized at the end of the turn. I could change this but I'm not actually sure its even necessary
func commit_action(caster,desc,obj,cursor_pos = false,top_level:=true):
	if desc == "precast":
		var line_to_del = turn_history.filter(func (x): return (x[2] == 'precast' and x[3] == obj)  )
		if line_to_del:
			var rm_idx = line_to_del[0][0]
			turn_history.remove_at(rm_idx)
			for i in range(rm_idx,turn_history.size()):
				turn_history[i][0] = i
			
	turn_history.append([turn_history.size(),caster.alias,desc,obj,cursor_pos,top_level])

func get_spell_repetitions(spell_config,mixer):
	var count:=0
	var deleted_list:=[]
	#CLASSIC DUPLICATION ISSUE GODDAMN
	var xs = turn_history.duplicate()
	xs.reverse()
	for action in xs:
		if action[1]==mixer.alias:
			if action[2] == "remove":
				deleted_list.append(action[3])
			else:
				if action[3] not in deleted_list and action[2] in ["create","cast"]:
					if (
						(action[3] is Spell and spell_config['alias'] == action[3].alias) 
					or (action[3] is Grimoire and spell_config['alias'] == action[3].spell.alias)
					):
						count+=1
	return count


func serialize_turn():
	#preprocessing - remove items that just got created and removed
	#remove non top level actions
	var xs = turn_history.duplicate()
	xs.reverse()
	var obj_map := {}
	for i in range(xs.size()):
		if not xs[i][-1]:
			if xs[i][3] is Grimoire:
				xs[i][3].windup()
			else:
				xs[i][3].queue_free()
			xs[i] = null
			continue
		if xs[i][2] == "remove":
			obj_map[xs[i][3]] = [i]
		else:
			if obj_map.has(xs[i][3]):
				obj_map[xs[i][3]].append(i)
			
	
	for value in obj_map.values()	:
		if value.size()>1:
			for i in value:
				if xs[i][3] is Grimoire:
					xs[i][3].windup()
				else:
					xs[i][3].queue_free()
				xs[i] = null
	xs = xs.filter(func (x): return x!=null)
	xs.reverse()
	#processing - rectify ids,replace objects with dictionaries
	for i in range(xs.size()):
		xs[i][0] = i
		var y = xs[i][3]
		if y is Spell:
			y = {'alias': y.alias,'modifiers':y.modifiers,'id':y.id}
		elif y is Grimoire:
			y= {'spell_alias':y.spell.alias,'spell_modifiers':y.spell.modifiers,
			'type':y.type,'value':y.value,'precast_position':y.precast_position,'id':y.id,}
		xs[i][3] = y
		
		
	return {
		"turn": $Map.turn,
#		"actions": turn_history,
		"debug": xs
	}
	

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
#Spell woodland wonderland(very expensive) - every spell you cast will fill your empty slots with iron branches(stats+ can be planted
# to create jungle terrain). maybe some active to go with it

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
