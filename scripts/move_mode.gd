extends Mode
#Props is a unit
var move_grid:MapGrid
var update_grid := true
var path :=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update_grid:
		move_grid= map.gen_move_grid(props[0])
		map.display_move_grid(move_grid)
		update_grid = false
		
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	move_grid= map.gen_move_grid(props[0])
	map.display_move_grid(move_grid)
	update_grid = false
	if cursor.cursor_tile in move_grid.dict:
		path = map.find_path(move_grid,cursor.cursor_tile,[],0)
		map.display_path(path)
	cursor.cursor_changed.connect(_on_cursor_changed)
	
func _on_cursor_changed():
	if path:
		map.clear_path(path)
	if cursor.cursor_tile in move_grid.dict:
		path = map.find_path(move_grid,cursor.cursor_tile,[],0)
		map.display_path(path)
		hud.stats_display(str(props[0].move_stat -path[1]))

func windup(clear_display:bool=false)->void:
	map.clear_grid(move_grid)
	if path:
		map.clear_path(path)
	super.windup(clear_display)
	
