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
	var visible_tiles=Set.new([])
	for ally in allies:
		visible_tiles=visible_tiles.union(Map.gen_vision_grid(ally))
	for tile in visible_tiles:
		Map.erase_cell(2,tile)

func display_vision_grid():
	for tile in Map.gen_vision_grid(self):
		Map.set_cell(3,tile,Map.terrains['sea']["sprite_id"],Map.terrains['sea']["sprite_atlas"])
	
func display_move_grid():
	for tile in Map.gen_move_grid(self):
		Map.set_cell(3,tile,Map.terrains['ocean']["sprite_id"],Map.terrains['ocean']["sprite_atlas"])


func _on_cursor_area_entered(area):
	print("true")
