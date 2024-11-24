class_name PrecastMode
extends Display

var unsafe_text
var cast_grid:MapGrid
var cast_range_grid:MapGrid
var precast_position_type 
#props will be the player,grimoire
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("select_confirm"):
		if cursor.cursor_tile in cast_range_grid.dict:
			match precast_position_type:
				Grimoire.Precast_Position_Type.ABSOLUTE:
					props[1].precast_position = {'type':precast_position_type,'position':cursor.cursor_tile}
				Grimoire.Precast_Position_Type.RELATIVE:
					props[1].precast_position = {
							'type':precast_position_type,
							'origin':map.local_to_map(props[0].position) ,
							'position': cursor.cursor_tile}
			game.commit_action(props[0],"precast",props[1])
			map.clear_grid(cast_grid,'cast')
			map.clear_grid(cast_range_grid,"cast_range")
			windup()
	if Input.is_action_just_pressed("cancel_action"):
		windup()

func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	update = false
	
#	tests()
#
	#dropdowns
	for type in Grimoire.Grimoire_Type:
		if Grimoire.Grimoire_Type[type] != Grimoire.Grimoire_Type.NONE:
			$CanvasLayer/Grimoire_Dropdown.add_item(type)
	$CanvasLayer/Grimoire_Dropdown.select(props[1].type -1)
	for terrain in map.mod_to_terrain.values():
		$CanvasLayer/Grimoire_Val_Terrain.add_item(terrain)
	default_grimoire_value(props[1].type)
	for type in Grimoire.Precast_Position_Type:
		$CanvasLayer/Precast_Position_Type.add_item(type)
		
	cursor.cursor_changed.connect(_on_cursor_changed)
	
	cast_range_grid = MapGrid.new(map.field_of_prop(map.local_to_map(props[0].position),
		"cast_range_cost",props[1].spell.cast_range,[],0,false))
	map.display_grid(cast_range_grid,"cast_range")
	
	
	if props[1].precast_position:
		precast_position_type = props[1].precast_position['type']
		$CanvasLayer/Precast_Position_Type.select(precast_position_type)
		var cursor_pos
		match precast_position_type:
			Grimoire.Precast_Position_Type.ABSOLUTE:
				cursor_pos = props[1].precast_position['position']
				
			Grimoire.Precast_Position_Type.RELATIVE:
				var unit_xy = map.local_to_map(props[0].position)
				cursor_pos = cursor.calc_relative_cursor(unit_xy,props[1].precast_position)

		if cursor_pos in cast_range_grid.dict:
			cast_grid = map.gen_cast_grid(props[1].spell,cursor_pos)
			map.display_grid(cast_grid,"cast")
			cursor.update(cursor_pos)
			
	else:
		precast_position_type = Grimoire.Precast_Position_Type.RELATIVE
					
				

func _on_cursor_changed():
	if cast_grid:
		map.clear_grid(cast_grid,'cast')
	if  cursor.cursor_tile in cast_range_grid.dict:
		cast_grid = map.gen_cast_grid(props[1].spell,cursor.cursor_tile)
		map.display_grid(cast_grid,"cast")
	
	
func windup()->void:
	if unsafe_text:
		_on_grimoire_value_text_submitted(unsafe_text)
	if cast_grid:
		map.clear_grid(cast_grid,'cast')
	if cast_range_grid:
		map.clear_grid(cast_range_grid,"cast_range")
	super()
	
func default_grimoire_value(type:Grimoire.Grimoire_Type):
	match type:
		Grimoire.Grimoire_Type.ON_DMG:
			$CanvasLayer/Grimoire_Val.show()
			$CanvasLayer/Grimoire_Val_Terrain.hide()
			$CanvasLayer/Grimoire_Val.text =""
			if not update:
				$CanvasLayer/Grimoire_Val.placeholder_text= str(props[1].value)+"%"
				
			else:
				$CanvasLayer/Grimoire_Val.placeholder_text= "100%"
				props[1].value = 100
		Grimoire.Grimoire_Type.ON_TERRAIN_CHANGE:
			$CanvasLayer/Grimoire_Val.hide()
			$CanvasLayer/Grimoire_Val_Terrain.show()
			if not update:
				$CanvasLayer/Grimoire_Val_Terrain.select(map.terrains[props[1].value]['elevation'] * 4 + map.terrains[props[1].value]['moisture'])
			else:
				$CanvasLayer/Grimoire_Val_Terrain.select(0)
				props[1].value = map.mod_to_terrain.values()[0]

func _on_grimoire_val_terrain_item_selected(index):
	$CanvasLayer/Grimoire_Val_Terrain.release_focus()
	props[1].value = map.mod_to_terrain.values()[index]

func _on_grimoire_dropdown_selected(index):
	$CanvasLayer/Grimoire_Dropdown.release_focus()
	props[1].type = Grimoire.Grimoire_Type.values()[index+1]
	update=true
	default_grimoire_value(props[1].type)

func _on_grimoire_value_text_changed(new_text):
	$CanvasLayer/Grimoire_Val/Grimoire_Val_Timer.start()
	unsafe_text = new_text

func _on_grimoire_value_timer_timeout():
	_on_grimoire_value_text_submitted(unsafe_text)

func _on_grimoire_value_text_submitted(new_text):
	var input = int(new_text)
	match props[1].type:
		Grimoire.Grimoire_Type.ON_DMG:
			if input < 100 and input > 0:
				props[1].value = input
			else:
				default_grimoire_value(props[1].type)

func _on_precast_position_type_selected(index):
	precast_position_type = Grimoire.Precast_Position_Type.values()[index]
	
	
func tests():
	var results=[]
	if cursor.calc_relative_cursor(Vector2i(8, 7),{ "type": 0, "origin": Vector2i(8, 8), "position": Vector2i(6, 8) })== Vector2i(6, 7):
		results.append(true)
	else:
		results.append(false)
	if cursor.calc_relative_cursor(Vector2i(9, 7),{ "type": 0, "origin": Vector2i(8, 8), "position": Vector2i(8, 9) })== Vector2i(8, 8):
		results.append(true)
	else:
		results.append(false)
	
	for i in range(len(results)):
		if results[i]:
			print("Test "+ str(i) + " passed")
		else:
			print("Test "+ str(i) + " failed")
	
