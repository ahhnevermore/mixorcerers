extends Mode

var unsafe_text
var cast_grid:MapGrid
var cast_range_grid:MapGrid
var precast_position_type = Grimoire.Precast_Position_Type.RELATIVE
#props will be the player,grimoire
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	update = false
	
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
	

func _on_cursor_changed():
	pass
	
	
	
func windup()->void:
	if unsafe_text:
		_on_grimoire_value_text_submitted(unsafe_text)
	super.windup()
	
func default_grimoire_value(type:Grimoire.Grimoire_Type):
	match type:
		Grimoire.Grimoire_Type.ON_DMG:
			$CanvasLayer/Grimoire_Val.show()
			$CanvasLayer/Grimoire_Val_Terrain.hide()
			$CanvasLayer/Grimoire_Val.text =""
			if not update:
				$CanvasLayer/Grimoire_Val.placeholder_text= str(props[1].value)+"%"
				print("here")
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
	
	
