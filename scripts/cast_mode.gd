extends Mode

#Invariant - there should be props[1] for anything to be cast
var cast_range_grid:MapGrid
var cast_grid:MapGrid
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update and props[1] is Spell:
		update = false
		if cast_grid:
			map.clear_grid(cast_grid,'cast')
		if cast_range_grid:
			map.clear_grid(cast_range_grid,"cast_range")
		
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
	
	if update and props[1] is Grimoire:
		update = false
		if cast_grid:
			map.clear_grid(cast_grid,'cast')
		if cast_range_grid:
			map.clear_grid(cast_range_grid,"cast_range")
		var precast_mode = game.precast_mode_scene.instantiate()
		precast_mode.setup(game,map,cursor,hud,props)

	if Input.is_action_just_pressed("cancel_action"):
		self.windup()
			
	
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	alias = 'cast'
	hud.clear_inventory_display()
	hud.inventory_display(props[0].inventory,self)
	update=false
	cursor.cursor_changed.connect(_on_cursor_changed)
	
func _on_cursor_changed():
	if cast_grid:
		map.clear_grid(cast_grid,'cast')
	if props.size()> 1 and props[1] is Spell and cursor.cursor_tile in cast_range_grid.dict:
			cast_grid = map.gen_cast_grid(props[1],cursor.cursor_tile)
			map.display_grid(cast_grid,"cast")
				
		
func cast(spell:Spell,target:MapGrid):
	
	var tiles= target.dict.keys().map(func(x):return map.get_tile(x))
	var collisions = find_collisions(target.dict.keys())

	for collision in collisions:
		var terrain_stats = map.terrains[map.get_terrain(collision[1])]
		var unit = collision[0]
		var damage = calc_damage(spell,terrain_stats)
		
		if spell.terrain_mod:
			pass
		
		var on_dmg_grimoires = unit.damage_trigger(damage)
		on_dmg_grimoires.sort_custom(func(a,b):return a.value > b.value)
	
		for grimoire in on_dmg_grimoires:
			if unit.xy == collision[1].xy:
				var index = unit.inventory.find(grimoire)
				unit.inventory[index]=null
				#starts infinite loop if casted on the same location with dmg grimoire on same location if its not first removed
				cast(grimoire.spell,map.gen_cast_grid(grimoire.spell,
				cursor.calc_relative_cursor(unit.xy,grimoire.precast_position) if grimoire.precast_position else unit.xy))
				
			elif unit.xy in target.dict.keys():
				collisions.append(unit,map.get_tile(unit.xy))
				
		#after on_dmg_grimoires are resolved
		if unit.xy == collision[1].xy:
			unit.modified_stats['health'] -= damage
			if unit.alias == 'Player':
				hud.stats_display([['health',unit.modified_stats['health']]])
			
	#modify terrain
	if spell.terrain_mod:
		for tile in tiles:
			tile.update_terrain(get_modded_terrain(map.terrains[map.get_terrain(tile)],spell.terrain_mod),map.turn)
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
	for i in range(game.mode.size()-1,-1,-1):
		if game.mode[i] == self:
			break
		else:
			game.mode[i].windup()
	if props.size()>1:
		props=[props[0]]
	props.append(val)
	update = true

func log_action()->void:
	game.turn_history.append([props[1].alias,cursor.cursor_tile])

func calc_damage(spell,terrain_stats):
	var damage
	match spell.dmg_dist:
		Spell.DMG_Distribution.CLEAN:	#damage distribution will have damage varying across the grid
			#Calculate dmg
			damage = (spell.fire_dmg * (1+terrain_stats['fire_affin']) +
					spell.water_dmg * (1+terrain_stats['water_affin']) +
					spell.earth_dmg * (1+terrain_stats['earth_affin']) +
					spell.air_dmg * (1+terrain_stats['air_affin'])
			)
	return damage

func find_collisions(tiles:Array):
	var res = []
	for listener in game.listeners:
		if listener.xy in tiles:
			res.append([listener,map.get_tile(listener.xy)])
	return res	

func get_modded_terrain(terrain_stats, terrain_mod):
	var new_terrain_id = [terrain_stats['elevation']+ terrain_mod[0],terrain_stats['moisture']+ terrain_mod[1]]
	new_terrain_id[0] = 0 if new_terrain_id[0] < 0 else (2 if new_terrain_id[0]> 2 else new_terrain_id[0])
	new_terrain_id[1] = 0 if new_terrain_id[1] < 0 else (3 if new_terrain_id[1]> 3 else new_terrain_id[1])
	
	return map.mod_to_terrain[new_terrain_id]
