extends Node2D

var Map
var vision_stat = 4
var vision_stat_modifier=0
var move_stat = 3
var move_stat_modifier =0
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
	var visible_tiles=MapGrid.new([])
	for ally in allies:
		visible_tiles=visible_tiles.union(Map.gen_vision_grid(ally))
	for tile in visible_tiles:
		Map.erase_cell(2,tile[0])

func display_vision_grid(grid):
	for tile in grid:
		Map.set_cell(3,tile[0],Map.terrains['sea']["sprite_id"],Map.terrains['sea']["sprite_atlas"])
	
func display_move_grid(grid):
	for tile in grid:
		Map.set_cell(3,tile[0],Map.terrains['ocean']["sprite_id"],Map.terrains['ocean']["sprite_atlas"])

func move():
	var move_grid = Map.gen_move_grid(self)
	display_move_grid(move_grid)
	for i in Map.find_path(move_grid,Vector2i(4,4),[]):
		print(i)


func _on_cursor_area_entered(_area):
	print(true)
#
