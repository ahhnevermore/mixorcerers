extends Unit

var alias = "Enemy"
var game:Game
var map:Map
var commands = ["move grid","vision grid"]
var inventory

# Called when the node enters the scene tree for the first time.

func _ready():
	game=get_parent()
	map=get_parent().get_node("Map")
	xy = map.map_file[map.enemy +"_start_position"]
	position= map.map_to_local(xy)
	inventory =[Spell.new(game.spells["fireball"],[],{}),Spell.new(game.spells["fireball"],[],{}),null,null,null,null,null,null]
	game.listeners.append(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	pass



