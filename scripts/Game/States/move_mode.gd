class_name MoveMode
extends Mode
#Props is a unit
var move_grid:MapGrid
var path :=[]
var initial_move
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		move_grid= map.gen_move_grid(props[0])
		map.display_grid(move_grid,'move')
		update = false
	if Input.is_action_just_pressed("select_confirm") and path:
		map.display_grid(map.gen_vision_grid(props[0]),'fog')
		map.clear_grid(move_grid,'move')
		
		props[0].xy = path[0][-1]
		props[0].position = map.map_to_local(path[0][-1])
		
		props[0].gen_visible_tiles()
		map.update_vision(props[0].visible_tiles)
		props[0].display_vision([])
		
		
		props[0].modified_stats['move'] = initial_move - path[1]
		initial_move= props[0].modified_stats['move']	
		map.clear_path(path)
		log_action()
		if initial_move == 0:
			windup()
		update = true
	if Input.is_action_just_pressed("cancel_action"):
		windup()
	
func _init(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	alias = "move"
	move_grid= map.gen_move_grid(props[0])
	map.display_grid(move_grid,'move')
	initial_move=props[0].modified_stats['move']
	_on_cursor_changed()
	cursor.cursor_changed.connect(_on_cursor_changed)
	if initial_move == 0:
			windup()
	update = false
	
func _on_cursor_changed():
	if path:
		map.clear_path(path)
	if cursor.cursor_tile in move_grid.dict:
		path = map.find_path(move_grid,cursor.cursor_tile,[],0)
		map.display_path(path)
		hud.stats_display([['move',props[0].modified_stats['move'] -path[1]]])
	else:
		hud.stats_display([['move',initial_move]])
		path=[]

func windup()->void:
	map.clear_grid(move_grid,"move")
	hud.stats_display([['move',initial_move]])
	if path:
		map.clear_path(path)
	super()
	
func log_action()->void:
	game.commit_action(props[0],"move",false,props[0].xy)
