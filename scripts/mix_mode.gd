extends Mode

# Called when the node enters the scene tree for the first time.
var internal_orbs
var grimoire_type = 'None'
var spell
var stack:Array

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		orbs_display(internal_orbs)
	if Input.is_action_just_pressed("cancel_action"):
		if stack:
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
			stack_display(stack)
			spell_display(stack)
		else:
			self.windup()


func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	internal_orbs=props[0].orbs.duplicate()
	$CanvasLayer/Grimoire_Dropdown.set_parent(self)
	$CanvasLayer/Orbs/FireButton.setup("Fire",self)
	$CanvasLayer/Orbs/WaterButton.setup("Water",self)
	$CanvasLayer/Orbs/EarthButton.setup("Earth",self)
	$CanvasLayer/Orbs/AirButton.setup("Air",self)

func stack_display(list):
	for child in $CanvasLayer/Stack.get_children():
		child.queue_free()
	for item in list:
		var label = Label.new()
		label.text = item
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
	
func _on_grimoire_dropdown_selected(index):
	grimoire_type = Grimoire.Grimoire_Type.keys()[index]
	print(grimoire_type)

func _on_button_message(val):
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
		stack_display(stack)
		orbs_display(internal_orbs)
		spell_display(stack)
		
