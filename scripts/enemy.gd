extends Unit


var alias = "Enemy"
var game:Game
var map:Map
var allies: Array
var commands = ["move grid","vision grid"]
var orbs = {"fire":10,"water":10,"earth":10,"air":10,"texture":0}
var inventory
var initial_stats = {'move':2,
			'vision':3,
			'health':100}
var modified_stats = initial_stats.duplicate(true)
var visible_tiles
# Called when the node enters the scene tree for the first time.

func _ready():
	game=get_parent()
	map=get_parent().get_node("Map")
	position= map.map_to_local(map.map_file[map.enemy +"_start_position"])
	allies.push_back(self)
	inventory =[Spell.new(game.spells["fireball"],[]),Spell.new(game.spells["fireball"],[])]
	game.listeners.append(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func gen_visible_tiles():
	visible_tiles=MapGrid.new([])
	for ally in allies:
		visible_tiles=visible_tiles.union(map.gen_vision_grid(ally))
	
func display_vision(grid):
	#checks this grid for updating vision
	if grid:
		for tile in grid:
			if tile[0] in visible_tiles.dict:
				map.gen_tile(map.get_tile(tile[0]))
	else:
		#updates all the vision
		for tile in visible_tiles:
			map.gen_tile(map.get_tile(tile[0]))
			map.erase_cell(2,tile[0])

func _on_cursor_area_entered(_area):
	print(true)



