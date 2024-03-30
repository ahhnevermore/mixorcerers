extends Mode

# Called when the node enters the scene tree for the first time.
var internal_orbs
var grimoire_type = 'None'
var spell
var stack:Array
var magycke_stack :Array
var unsafe_text:String
var grimoire_value=false
#percentage for On_DMG
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		orbs_display(internal_orbs)
	if Input.is_action_just_pressed("cancel_action"):
		if stack:
			if not magycke_stack:
				var elem = stack.pop_back()
				match elem:
					"Fire":
						internal_orbs['fire']+=1
					"Water":
						internal_orbs['water']+=1
					"Earth":
						internal_orbs['earth']+=1
					"Air":
						internal_orbs['air']+=1
			else:
				magycke_stack.pop_back()
				internal_orbs['magycke']+=1
			stack_display(stack,magycke_stack)
			spell_display(stack)
		else:
			self.windup()


func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	
	#orb bar
	internal_orbs=props[0].orbs.duplicate()
	$CanvasLayer/Orbs/FireButton.setup("Fire",self)
	$CanvasLayer/Orbs/WaterButton.setup("Water",self)
	$CanvasLayer/Orbs/EarthButton.setup("Earth",self)
	$CanvasLayer/Orbs/AirButton.setup("Air",self)
	$CanvasLayer/Control/MagyckeButton.setup("Magycke",self)
	
	# grimoire
	for type in Grimoire.Grimoire_Type:
		$CanvasLayer/Grimoire_Dropdown.add_item(type)
	for terrain in map.mod_to_terrain.values():
		$CanvasLayer/Grimoire_Val_Terrain.add_item(terrain)
	default_grimoire_value(grimoire_type)
	



func stack_display(xs,ys):
	for child in $CanvasLayer/Stack.get_children():
		child.queue_free()
	for x in xs:
		var label = Label.new()
		label.text = x
		$CanvasLayer/Stack.add_child(label)
	for y in ys:
		var label = Label.new()
		label.text = y
		$CanvasLayer/Stack.add_child(label)
		
func spell_display(list):
	var res ={'fire':0,'water':0,'earth':0,'air':0}
	for item in list:
		if item == 'Fire':
			res['fire'] += 1
		if item == 'Water':
			res['water'] += 1
		if item == 'Earth':
			res['earth'] += 1
		if item == 'Air':
			res['air'] += 1
	if res in game.recipes:
		$CanvasLayer/Spell.text = game.recipes[res]
	else:
		$CanvasLayer/Spell.text = 'None'
			
	
func orbs_display(orbs:Dictionary):
	$CanvasLayer/Orbs/FireCount.text= str(orbs['fire'])
	$CanvasLayer/Orbs/WaterCount.text= str(orbs['water'])
	$CanvasLayer/Orbs/EarthCount.text= str(orbs['earth']) 
	$CanvasLayer/Orbs/AirCount.text= str(orbs['air']) 
	$CanvasLayer/Control/MagyckeCount.text=str(orbs['magycke'])
	

func _on_button_message(val):
	if val != "Magycke":
		if stack.size() < 5:
			match val:
				"Fire":
					if internal_orbs['fire'] > 0:
						internal_orbs['fire'] -=  1
						stack.append(val)
				"Water":
					if internal_orbs['water'] > 0:
						internal_orbs['water'] -= 1
						stack.append(val)
				"Earth":
					if internal_orbs['earth'] > 0:
						internal_orbs['earth'] -= 1
						stack.append(val)
				"Air":
					if internal_orbs['air'] > 0:
						internal_orbs['air'] -= 1
						stack.append(val)
	else:
		if internal_orbs['magycke']>0:
			internal_orbs['magycke']-=1
			magycke_stack.append(val)
			
	stack_display(stack,magycke_stack)
	orbs_display(internal_orbs)
	spell_display(stack)
		
func windup()->void:
	for elem in stack:
		match elem:
				"Fire":
					internal_orbs['fire']+=1
				"Water":
					internal_orbs['water']+=1
				"Earth":
					internal_orbs['earth']+=1
				"Air":
					internal_orbs['air']+=1
	for elem in magycke_stack:
		internal_orbs['magycke']+=1
	props[0].orbs = internal_orbs.duplicate()
	super.windup()


func _on_grimoire_dropdown_selected(index):
	grimoire_type = Grimoire.Grimoire_Type.keys()[index]
	default_grimoire_value(grimoire_type)
	
	
func _on_grimoire_value_text_changed(new_text):
	$CanvasLayer/Grimoire_Val/Grimoire_Val_Timer.start()
	unsafe_text = new_text

func _on_grimoire_value_timer_timeout():
	_on_grimoire_value_text_submitted(unsafe_text)

func _on_grimoire_value_text_submitted(new_text):
	var input = int(new_text)
	match grimoire_type:
		'None':
			default_grimoire_value(grimoire_type)
		'On_DMG':
			if input < 100 and input > 0:
				grimoire_value = input
			else:
				default_grimoire_value(grimoire_type)
func default_grimoire_value(type:String):
	match type:
		'None':
			$CanvasLayer/Grimoire_Val.show()
			$CanvasLayer/Grimoire_Val_Terrain.hide()
			$CanvasLayer/Grimoire_Val.text =""
			$CanvasLayer/Grimoire_Val.placeholder_text=""
			grimoire_value=false
		'On_DMG':
			$CanvasLayer/Grimoire_Val.show()
			$CanvasLayer/Grimoire_Val_Terrain.hide()
			$CanvasLayer/Grimoire_Val.text =""
			$CanvasLayer/Grimoire_Val.placeholder_text="100%"
			grimoire_value = 100
		'On_Terrain_Change':
			$CanvasLayer/Grimoire_Val.hide()
			$CanvasLayer/Grimoire_Val_Terrain.show()
			grimoire_value = map.mod_to_terrain.values()[0]


func _on_grimoire_val_terrain_item_selected(index):
	grimoire_value = map.mod_to_terrain.values()[index]
