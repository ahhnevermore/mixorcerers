class_name Map
extends TileMap

var map_file:Dictionary	
var map:Array
var xw:int
var yw:int
var day:bool
var turn:int
var player:String
# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_file = load_map("default")
	map= map_file["tiles"]
	xw = map[0].size()
	yw = map.size()
	day = true
	turn = 0
	player = 'p1'
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func manhattan(a:Vector2i,b:Vector2i)->int:
	return abs(b.x-a.x)+ abs(b.y-a.y)

#PATH
func find_path(grid:MapGrid,end:Vector2i,nodes:Array,acc:int)->Array:
	var parent=grid.dict[end][1]
	nodes.push_front(end)
	if parent:
		find_path(grid,parent,nodes,acc)
		return [nodes,acc+grid.dict[end][0]]
	return [nodes,acc]

func display_path(path:Array)->void:
	for xy in path[0]:
		set_cell(4,xy,17,Vector2i(0,0))

func clear_path(path:Array)->void:
	for xy in path[0]:
		erase_cell(4,xy)	

#GRID	
func display_grid(grid:MapGrid,grid_type:String)->void:
	match grid_type:
		"move":
			for tile in grid:
				set_cell(3,tile[0],terrains['ocean']["sprite_id"],terrains['ocean']["sprite_atlas"])
		"vision":
			for tile in grid:
				set_cell(3,tile[0],terrains['sea']["sprite_id"],terrains['sea']["sprite_atlas"])
		"cast_range":
			for tile in grid:
				set_cell(3,tile[0],terrains['river']["sprite_id"],terrains['river']["sprite_atlas"])
		"map":
			for tile in grid:
				gen_tile(get_tile(tile[0]))
		"fog":
			for tile in grid:
				gen_fog(tile[0])
		"cast":
			for tile in grid:
				set_cell(4,tile[0],17,Vector2i(0,0))

func clear_grid(grid:MapGrid,grid_type:String)->void:
	match grid_type:
		"fog":
			for tile in grid:
				erase_cell(2,tile[0])
		"cast":
			for tile in grid:
				erase_cell(4,tile[0])
		_:
			for xy in grid:
				erase_cell(3,xy[0])

func gen_vision_grid(unit:Variant)->MapGrid:
	var xy = local_to_map(unit.position)
	var aug_vision = max(unit.modified_stats['vision'] + terrains[get_terrain(get_tile(xy))]["vision_bonus"],1)
	return MapGrid.new(field_of_prop(xy,"vision_cost",aug_vision,[],0,false))

func gen_move_grid(unit:Variant)->MapGrid:
	var xy = local_to_map(unit.position)
	var aug_move = unit.modified_stats['move']
	return MapGrid.new(field_of_prop(xy,"move_cost",aug_move,[],0,false))

func update_vision(arg_player:String,grid:MapGrid):
	for xy in grid:
		var tile = get_tile(xy[0])
		tile.cache = ""
		tile.terrain_list[0][arg_player]=turn

func get_surrounding_values(xy:Vector2i,prop:String)->Array:
	var list= get_surrounding_cells(xy).filter(func(xy):return xy[0]<xw and xy[0]>=0)\
									   .filter(func(xy):return xy[1]<yw and xy[1]>=0)
	var result=[]
	if prop in ["cast_cost","cast_range_cost"]:
		for cell in list:
			result.append([cell,1])
	else:
		for cell in list:
			result.append([cell,terrains[get_terrain(get_tile(cell))][prop]])
	return result

func field_of_prop(tile:Vector2i,prop:String,prop_value:int,old_frontier,acc:int,parent)->Array:
	var res = [[tile,[acc,parent]]]
	var new_frontier =get_surrounding_cells(tile)
	new_frontier.append(tile)
	for neighbour in get_surrounding_values(tile,prop):	
		if neighbour[0] not in old_frontier and (prop_value - neighbour[1]) >= 0:
			res.append_array(field_of_prop(neighbour[0],prop,prop_value-neighbour[1],new_frontier,acc+neighbour[1],tile))
	return res	
		
# on some turn a tile has changed
	#case 1- same turn, player 1 can see it-take
	#case 2- same turn, tile has changed but player cant see it-go further
	#case 3- older turn(replays)->go further
	#case 4- newer turn- take it if it is the most recent true for the player
	#player can be p1,p2,all

func get_tile(xy:Vector2i)->Tile:
	return map[xy[1]][xy[0]]

func get_terrain(tile:Tile)->String:
	if tile.cache:
		return tile.cache
	else:
		var terrain
		for terrain_instance in tile.terrain_list:
			if turn < terrain_instance[player]:
				continue
			else:
				terrain = terrain_instance['terrain']
				break
		return terrain
	
func gen_tile(tile:Tile)->void:
	var layer
	if day:
		layer=0
	else:
		layer=1
	var terrain=get_terrain(tile)
	set_cell(layer,tile.xy,terrains[terrain]["sprite_id"],terrains[terrain]["sprite_atlas"])
	tile.cache=terrain
	

func gen_fog(xy:Vector2i)->void:
	set_cell(2,xy,terrains["fog"]["sprite_id"],terrains["fog"]["sprite_atlas"])


#generates a new full map
func gen_map()->void:
	for row in map:
		for tile in row:
			if tile.xy[0] < xw and tile.xy[1] < yw:
				gen_tile(tile)
				gen_fog(tile.xy)




func load_map(filename:String)->Dictionary:
	if filename=='default':
		return {
			"tiles":
		[[Tile.new(Vector2i(0,0),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,0),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,0),[{'terrain':'swamp','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,0),[{'terrain':'delta','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,0),[{'terrain':'swamp','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,0),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,0),[{'terrain':'river','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,1),[{'terrain':'cliff','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,1),[{'terrain':'jungle','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,1),[{'terrain':'mountain_lake','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,1),[{'terrain':'snowcap','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,1),[{'terrain':'river','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,1),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,1),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,2),[{'terrain':'jungle','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,2),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,2),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,2),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,2),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,2),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,2),[{'terrain':'river','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,3),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,3),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,3),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,3),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,3),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,3),[{'terrain':'jungle','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,3),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,4),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,4),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,4),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,4),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,4),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,4),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,4),[{'terrain':'river','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,5),[{'terrain':'jungle','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,5),[{'terrain':'delta','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,5),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,5),[{'terrain':'delta','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,5),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,5),[{'terrain':'jungle','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,5),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}])],
		
		[Tile.new(Vector2i(0,6),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(1,6),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(2,6),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(3,6),[{'terrain':'ocean','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(4,6),[{'terrain':'sea','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(5,6),[{'terrain':'beach','all': 0,'p1':0,'p2': 0}]),
		Tile.new(Vector2i(6,6),[{'terrain':'river','all': 0,'p1':0,'p2': 0}])]
		
		],
		"player1_start_position":Vector2i(3,3),
		"player2_start_position":Vector2i(-1,-1),
		}
	else:
		return {}

var mod_to_terrain ={
	[0,0]:"chasm",
	[0,1]:"ravine",
	[0,2]:"underground_lake",
	[0,3]:"ocean",
	[1,0]:"desert",
	[1,1]:"beach",
	[1,2]:"delta",
	[1,3]:"sea",
	[2,0]:"plateau",
	[2,1]:"jungle",
	[2,2]:"swamp",
	[2,3]:"river",
	[3,0]:"cliff",
	[3,1]:"snowcap",
	[3,2]:"mountain_lake",
	[3,3]:"glacier"
}	
var terrains:={
	"chasm":{"sprite_id":0,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":0,"moisture":0,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"ravine":{"sprite_id":1,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":0,"moisture":1,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"underground_lake":{"sprite_id":2,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":0,"moisture":2,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"ocean":{"sprite_id":3,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":0,"moisture":3,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"desert":{"sprite_id":4,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":1,"moisture":0,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"beach":{"sprite_id":5,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":1,"moisture":1,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"delta":{"sprite_id":6,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":1,"moisture":2,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"sea":{"sprite_id":7,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":1,"moisture":3,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"plateau":{"sprite_id":8,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":2,"moisture":0,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"jungle":{"sprite_id":9,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":2,"moisture":1,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"swamp":{"sprite_id":10,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":2,"moisture":2,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"river":{"sprite_id":11,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":2,"moisture":3,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"cliff":{"sprite_id":12,"sprite_atlas":Vector2i(0,1),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":3,"moisture":0,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"snowcap":{"sprite_id":13,"sprite_atlas":Vector2i(0,1),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":3,"moisture":1,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"mountain_lake":{"sprite_id":14,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":3,"moisture":2,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"glacier":{"sprite_id":15,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":1,"move_cost":1,
	"elevation":3,"moisture":3,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25},
	
	"fog":{"sprite_id":16,"sprite_atlas":Vector2i(0,0),
	"vision_bonus":0,"vision_cost":5,"move_cost":100,
	"elevation":5,"moisture":5,
	"fire_affin":0.25,"water_affin":0.25,"earth_affin":0.25,"air_affin":0.25}
}
