extends Node


var replay = false
var cursorval
# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.gen_map()
	$Player1.display_vision()
	cursorval=[$Map.get_tile($Map.map_file["player1_start_position"]),
	$Map.get_terrain($Map.get_tile($Map.map_file["player1_start_position"]))]
	#$Player1.display_move_grid()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


#TODO
#Path finding algorithm
#Spells
#add spell prop to dict
#All terrain modifications have to set the cache of the terrain to null

func _on_cursor_tile(val):
	cursorval=val
	$HUD.terrain_display(val)
	
	
