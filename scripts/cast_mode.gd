extends Mode

#Invariant - there should be props[1] for anything to be cost
var cast_range_grid:MapGrid
var cast_grid:MapGrid
var vision_grid:MapGrid
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update and props[1] is Spell:
		update = false
		match props[1].cast_shape:
				Spell.cast_shapes.CIRCLE:
					cast_range_grid = MapGrid.new(map.field_of_prop(map.local_to_map(props[0].position),
					"cast_range_cost",props[1].cast_range,[],0,false))
					map.display_grid(cast_range_grid,"cast_range")
		_on_cursor_changed()
	if Input.is_action_just_pressed("select_confirm") and cast_grid and props.size()>1:
		cast(props[1],cast_grid)
		log_action()
		game._on_cursor_changed()
		var index = props[0].inventory.find(props[1])
		props[0].inventory[index]=null
		props.pop_back()
		
		hud.clear_inventory_display()
		hud.inventory_display(props[0].inventory,self)
		
	if Input.is_action_just_pressed("cancel_action"):
		self.windup()
			
	
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	alias = 'cast'
	vision_grid = map.gen_vision_grid(props[0])
	hud.clear_inventory_display()
	hud.inventory_display(props[0].inventory,self)
	update=false
	cursor.cursor_changed.connect(_on_cursor_changed)
	
func _on_cursor_changed():
	if cast_grid:
		map.clear_grid(cast_grid,'cast')
	if props.size()> 1 and props[1] is Spell and cursor.cursor_tile in cast_range_grid.dict:
		match props[1].cast_shape:
			Spell.cast_shapes.CIRCLE:
				cast_grid = MapGrid.new(map.field_of_prop(cursor.cursor_tile,
					"cast_cost",props[1].cast_dim[0],[],0,false))
				map.display_grid(cast_grid,"cast")
				
		
func cast(spell:Spell,target:MapGrid):
	var matches = []
	var tiles=[]
	for xy in target:
		var tile = map.get_tile(xy[0])
		tiles.append(tile)
		for listener in game.listeners:
			if map.map_to_local(tile.xy) == listener.position:
				matches.append([listener,tile])

	for match in matches:
		var terrain_stats = map.terrains[map.get_terrain(match[1])]
		var unit = match[0]
		unit.resolve_cast(spell,terrain_stats)
		if unit.alias == 'Player':
			hud.stats_display([['health',unit.modified_stats['health']]])
			
	#modify terrain
	if spell.elevation_mod != 0 or spell.moisture_mod != 0:
		for tile in tiles:
			var elevation
			if map.terrains[map.get_terrain(tile)]['elevation']+spell.elevation_mod < 0:
				elevation = 0
			elif map.terrains[map.get_terrain(tile)]['elevation']+spell.elevation_mod >2:
				elevation = 2
			else:
				elevation =  map.terrains[map.get_terrain(tile)]['elevation']+spell.elevation_mod
			var moisture
			if map.terrains[map.get_terrain(tile)]['moisture']+ spell.moisture_mod < 0:
				moisture=0
			elif map.terrains[map.get_terrain(tile)]['moisture']+ spell.moisture_mod>3:
				moisture=3
			else:
				moisture=map.terrains[map.get_terrain(tile)]['moisture']+ spell.moisture_mod
				
			tile.terrain_list.push_front({'terrain':map.mod_to_terrain[[elevation,moisture]],'all':map.turn,'p':INF})
			map.update_vision(props[0].visible_tiles)
			props[0].display_vision([])
			
	
	
	map.clear_grid(cast_grid,'cast')
	map.clear_grid(cast_range_grid,'cast_range')
				
	
	
func windup():
	if cast_grid:
		map.clear_grid(cast_grid,'cast')
	if cast_range_grid:
		map.clear_grid(cast_range_grid,"cast_range")
	hud.clear_inventory_display()
	hud.inventory_display_uninteractive(props[0].inventory)
	super.windup()

func _on_button_message(val):
	if props.size()>1:
		props=[props[0]]
	props.append(val)
	update = true

func log_action()->void:
	game.turn_history.append([props[1].alias,cursor.cursor_tile])
