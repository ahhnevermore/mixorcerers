extends TileMap
var map_file	
var map
var xw
var yw
# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_file = load_map("default")
	map= map_file["tiles"]
	xw = map[0].size()
	yw = map.size()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


class Tile:
	var xy:Vector2i  
	var terrain_list:Array
	#[{terrain:beach, turn: 1, p1: true, p2: true}]
	func _init(arg_xy,arg_terrain):
		self.xy=arg_xy
		self.terrain_list=arg_terrain

func gen_vision_grid(unit):
	var visible_tiles={}
	var xy = Map.local_to_map(unit.position)
	var aug_vision = max(unit.vision + unit.vision_modifier+ Map.get_terrain(xy)["vision_bonus"],1)
	for tile in Map.field_of_prop(xy,"vision_cost",aug_vision,[]):
		visible_tiles[tile]=true 
	return visible_tiles
	
func gen_move_grid(unit):
	var move_grid_tiles={}
	var xy = Map.local_to_map(unit.position)
	var aug_move = max(unit.move + unit.move_modifier,1)
	for tile in Map.field_of_prop(xy,"move_cost",aug_move,[]):
		move_grid_tiles[tile]=true
	return move_grid_tiles
		
func gen_tile(tile:Tile,day:bool,turn:int)->void:
	var layer
	if day:
		layer=0
	else:
		layer=1
	for terrain_instance in tile.terrain_list:
		
	set_cell(layer,tile.xy,terrains[tile.terrain]["sprite_id"],terrains[tile.terrain]["sprite_atlas"])
	

func gen_fog(tile):
	set_cell(2,tile.xy,terrains["fog"]["sprite_id"],terrains["fog"]["sprite_atlas"])
#generates a new full map
func gen_map()->void:
	for row in map:
		for tile in row:
			if tile.xy[0] < xw and tile.xy[1] < yw:
				gen_tile(tile,get_parent().day,get_parent().turn)
				gen_fog(tile)
				
func load_map(filename)->Dictionary:
	if filename=='default':
		return {
			"tiles":
		[[Tile.new(Vector2i(0,0),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,0),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,0),[{'terrain':'swamp','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,0),[{'terrain':'delta','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,0),[{'terrain':'swamp','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,0),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,0),[{'terrain':'river','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,1),[{'terrain':'cliff','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,1),[{'terrain':'jungle','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,1),[{'terrain':'mountain_lake','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,1),[{'terrain':'snowcap','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,1),[{'terrain':'river','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,1),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,1),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,2),[{'terrain':'jungle','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,2),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,2),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,2),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,2),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,2),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,2),[{'terrain':'river','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,3),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,3),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,3),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,3),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,3),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,3),[{'terrain':'jungle','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,3),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,4),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,4),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,4),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,4),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,4),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,4),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,4),[{'terrain':'river','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,5),[{'jungle':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,5),[{'terrain':'delta','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,5),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,5),[{'terrain':'delta','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,5),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,5),[{'terrain':'jungle','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,5),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}])],
		
		[Tile.new(Vector2i(0,6),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(1,6),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(2,6),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(3,6),[{'terrain':'ocean','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(4,6),[{'terrain':'sea','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(5,6),[{'terrain':'beach','turn': 0,'p1':true,'p2': true}]),
		Tile.new(Vector2i(6,6),[{'terrain':'river','turn': 0,'p1':true,'p2': true}])]
		
		],
		"player1_start_position":Vector2i(3,3),
		"player2_start_position":Vector2i(-1,-1),
		}
	else:
		return {}

func get_surrounding_values(xy:Vector2i,prop:String):
	var list= get_surrounding_cells(xy).filter(func(xy):return xy[0]<xw).filter(func(xy):return xy[1]<yw)
	var result=[]
	for cell in list:
		result.append([cell,get_terrain(cell)[prop]])
	return result

func field_of_prop(tile:Vector2i,prop:String,prop_value:int,old_frontier):
	var res = [tile]
	var new_frontier =get_surrounding_cells(tile)
	new_frontier.append(tile)
	for neighbour in get_surrounding_values(tile,prop):	
		if neighbour[0] not in old_frontier and prop_value - neighbour[1] > 0:
			res.append_array(field_of_prop(neighbour[0],prop,prop_value-neighbour[1],new_frontier))
	return res	

func get_terrain(xy:Vector2i):
	return terrains[map[xy[1]][xy[0]].terrain]

var terrains={
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
