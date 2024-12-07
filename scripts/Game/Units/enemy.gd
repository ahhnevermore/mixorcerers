extends Unit

var alias = "Enemy"

var commands = ["move grid","vision grid"]

# Called when the node enters the scene tree for the first time.

func _ready():
	super._ready()
	xy = map.map_file[game.enemy_label +"_start_position"]
	position= map.map_to_local(xy)
	inventory =[null,null,null,null,
				null,null,null,null
	#Spell.new(game.spells["fireball"],[],{}),Spell.new(game.spells["fireball"],[],{}),
	#Grimoire.new(Spell.new(game.spells["fireball"],[],{}),Grimoire.Grimoire_Type.ON_DMG,100),null,null,null,null,null
	]
	#inventory[2].precast_position = {
							#'type':Grimoire.Precast_Position_Type.RELATIVE,
							#'origin':Vector2i(2,7) ,
							#'position': Vector2i(4,8)}
	game.listeners.append(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	pass
