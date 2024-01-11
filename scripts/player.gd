extends Node2D

var Map
var vision = 4
var vision_modifier=0
var move = 3
var move_modifier =0
var allies: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	Map=get_parent().get_node("Map")
	position= Map.map_to_local(Map.map_file["player1_start_position"])
	allies.push_back(self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func display_vision():
	var visible_tiles={}
	for ally in allies:
		for tile in Map.gen_vision_grid(ally):
			Map.erase_cell(2,tile)
		


	


		
			
	
	

	


func _on_cursor_area_entered(area):
	print("true")
