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
# Called when the node enters the scene tree for the first time.
func _ready():
	select_mode_scene = load("res://scenes/select_mode.tscn")
	base_mode_scene = load("res://scenes/base_mode.tscn")
	move_mode_scene=load("res://scenes/move_mode.tscn")
	cast_mode_scene = load("res://scenes/cast_mode.tscn")
	mix_mode_scene = load("res://scenes/mix_mode.tscn")
	$Map.gen_map()
	$Player.display_vision()
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
#Path finding algorithm
#Spells
#add spell prop to dict
#All terrain modifications have to set the cache of the terrain to null

func _on_cursor_changed()->void:
	$HUD.terrain_display($Map.get_terrain($Map.get_tile($Cursor.cursor_tile)))
