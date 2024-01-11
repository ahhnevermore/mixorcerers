class_name  Tile

var xy:Vector2i  
var terrain_list:Array
var cache:String
#[{terrain:beach,all: p1: turn they saw, p2: turn they saw}]max value 10000
func _init(arg_xy,arg_terrain):
	self.xy=arg_xy
	self.terrain_list=arg_terrain
	self.cache=""
