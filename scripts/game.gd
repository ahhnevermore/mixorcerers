class_name Game
extends Node

var replay :bool = false
var mode :Array =[]
var select_mode_scene:PackedScene
var base_mode_scene:PackedScene
var move_mode_scene:PackedScene
var grid_mode_scene:PackedScene
var cast_mode_scene:PackedScene
var mix_mode_scene:PackedScene
var display_grid_mode_scene:PackedScene
var turn_history:Array
var listeners:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	select_mode_scene = load("res://scenes/select_mode.tscn")
	base_mode_scene = load("res://scenes/base_mode.tscn")
	move_mode_scene=load("res://scenes/move_mode.tscn")
	cast_mode_scene = load("res://scenes/cast_mode.tscn")
	mix_mode_scene = load("res://scenes/mix_mode.tscn")
	display_grid_mode_scene= load("res://scenes/display_grid_mode.tscn")

	$Map.gen_map()
	$Player.gen_visible_tiles()
	$Player.display_vision([])
	#$Player1.display_move_grid()
	_on_cursor_changed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not mode and Input.is_action_just_pressed("select_confirm"):
		$Cursor/RepeatDelay.stop()
		var select_mode = select_mode_scene.instantiate()
		select_mode.setup(self,$Map,$Cursor,$HUD,[])



#TODO
#add spell stats when selecting them in cast mode
#modify cast spell to not apply damage but instead sublet it to the listeners
#mix mode- additional cost
#			replacing spells and refunding costs
#precasting grimoires
#Spells - various dmg distributions, various spells,various casts
#add sprites for spells
#add sound effects for spells and tiles
# mod sprites for terrain
#create a game moves data structure, then make the enemy perform its moves
#write turns to file
#turn transition

#COMPLETED
#Path finding algorithm and movement - Completed
#vision - done
#add spell prop to dict-not sure what it means but done
#add enemy
#loading maps from filea
#camera


# all the user content in user://
# after about 10 recursive depth, program has noticeable lag
#All terrain modifications have to set the cache of the terrain to null

func _on_cursor_changed()->void:
	$HUD.terrain_display($Map.get_terrain($Map.get_tile($Cursor.cursor_tile)))

var spells = {
	"fireball":{
		'alias':"fireball",'sprite':"res://icon.svg",
		'cast_range':2,'cast_shape':Spell.cast_shapes.CIRCLE,'cast_dim':[1],
		'fire_dmg':10.0,'water_dmg':0.0,'earth_dmg':0.0,'air_dmg':0.0, 'dmg_dist':Spell.DMG_Distribution.CLEAN,
		'gen_unit':false,'gen_artifact':false,
		'elevation_mod': 0,'moisture_mod':-1,
		'magycke_mod':[['dmg',{'fire':5,'water':0,'earth':0,'air':0}],['burn',{'duration':2,'dmg':5}]],
		'day_mod':[[]],'night_mod':[[]],
		'modifiers':[['vision',{'duration':2}]],
		'repeat_cost':{'fire':1,'water':0,'earth':0,'air':0},
		'grimoire_cost':{'fire':1,'water':0,'earth':0,'air':0}}
}

var recipes= {
	{'fire':3,'water':0,'earth':0,'air':0 }: 'fireball'
}
