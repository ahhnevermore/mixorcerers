extends Unit

var alias = "Enemy"
var game:Game
var map:Map
var commands = ["move grid","vision grid"]
var inventory
var initial_stats = {'move':2,
			'vision':3,
			'health':100}
var modified_stats = initial_stats.duplicate(true)
# Called when the node enters the scene tree for the first time.

func _ready():
	game=get_parent()
	map=get_parent().get_node("Map")
	position= map.map_to_local(map.map_file[map.enemy +"_start_position"])
	inventory =[Spell.new(game.spells["fireball"],[]),Spell.new(game.spells["fireball"],[])]
	game.listeners.append(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	pass



