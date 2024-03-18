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
var turn_history:Array
var listeners:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	select_mode_scene = load("res://scenes/select_mode.tscn")
	base_mode_scene = load("res://scenes/base_mode.tscn")
	move_mode_scene=load("res://scenes/move_mode.tscn")
	cast_mode_scene = load("res://scenes/cast_mode.tscn")
	mix_mode_scene = load("res://scenes/mix_mode.tscn")
	$Map.gen_map()
	$Player.gen_visible_tiles()
	$Player.display_vision([])
	#$Player1.display_move_grid()
	_on_cursor_changed()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	if not mode and Input.is_action_just_pressed("select_confirm"):
		$Cursor/RepeatDelay.stop()
		var select_mode = select_mode_scene.instantiate()
		select_mode.setup(self,$Map,$Cursor,$HUD,[])



#TODO

#Spells - kind of


#add sprites for spells
#add sound effects for spells and tiles
# mod sprites for terrain
#add enemy
#write turns to file

#COMPLETED
#Path finding algorithm and movement - Completed
#vision - done
#add spell prop to dict-not sure what it means but done


#All terrain modifications have to set the cache of the terrain to null

func _on_cursor_changed()->void:
	$HUD.terrain_display($Map.get_terrain($Map.get_tile($Cursor.cursor_tile)))

var spells = {
	"fireball":{'alias':"fireball",'cast_range':2,'cast_shape':Spell.cast_shapes.CIRCLE,'cast_dim':[1],
				'fire_dmg':10.0,'water_dmg':0.0,'earth_dmg':0.0,'air_dmg':0.0,
				'sprite':"res://icon.svg",'gen_unit':false,'gen_item':false,
				'elevation_mod': 0,'moisture_mod':-1,'modifier':['vision']}
}
