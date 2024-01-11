extends Node


var replay = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.gen_map()
	$Player1.display_vision()
	$Player1.display_move_grid()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


#TODO
#Path finding algorithm
#Spells
#add spell prop to dict
