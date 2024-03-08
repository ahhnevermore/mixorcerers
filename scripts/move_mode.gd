extends Mode
#Props is a unit
var move_grid:MapGrid
var vision_grid:MapGrid
var update_grid := true
var path :=[]
var initial_move
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update_grid:
		move_grid= map.gen_move_grid(props[0])
		vision_grid=map.gen_vision_grid(props[0])
		map.clear_fog(vision_grid)
		map.display_move_grid(move_grid)
		update_grid = false
	if Input.is_action_just_pressed("select_confirm") and path:
		for xy in vision_grid:
			map.gen_fog(xy[0])
		map.clear_grid(move_grid)
		props[0].position = map.map_to_local(path[0][-1])
		props[0].move_stat = initial_move - path[1]
		initial_move= props[0].move_stat	
		map.clear_path(path)
		update_grid = true
	if Input.is_action_just_pressed("cancel_action"):
		self.windup()
	
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	move_grid= map.gen_move_grid(props[0])
	map.display_move_grid(move_grid)
	vision_grid=map.gen_vision_grid(props[0])
	update_grid = false
	initial_move=props[0].move_stat
	_on_cursor_changed()
	cursor.cursor_changed.connect(_on_cursor_changed)
	
func _on_cursor_changed():
	if path:
		map.clear_path(path)
	if cursor.cursor_tile in move_grid.dict:
		path = map.find_path(move_grid,cursor.cursor_tile,[],0)
		map.display_path(path)
		hud.stats_display(str(props[0].move_stat -path[1]))
	else:
		hud.stats_display(str(initial_move))
		path=[]

func windup()->void:
	map.clear_grid(move_grid)
	hud.stats_display(str(initial_move))
	if path:
		map.clear_path(path)
	super.windup()
	
