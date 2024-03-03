extends Node2D

var Map
var vision_stat = 3
var vision_stat_modifier=0
var move_stat = 2
var move_stat_modifier =0
var allies: Array
var commands = ["move","vision","cast","mix"]
# Called when the node enters the scene tree for the first time.

func _ready():
	Map=get_parent().get_node("Map")
	position= Map.map_to_local(Map.map_file["player1_start_position"])
	allies.push_back(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func display_vision():
	var visible_tiles=MapGrid.new([])
	for ally in allies:
		visible_tiles=visible_tiles.union(Map.gen_vision_grid(ally))
	for tile in visible_tiles:
		Map.erase_cell(2,tile[0])


		


func _on_cursor_area_entered(_area):
	print(true)
#

