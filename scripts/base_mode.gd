extends Mode
#EXPECTS PROPS to be just 1 unit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update and props[0]:
		update= false
		hud.internal_stats = props[0].modified_stats.duplicate()
		hud.stats_display([])
		hud.command_display(props[0].commands,self)
		hud.inventory_display_uninteractive(props[0].inventory)
	if Input.is_action_just_pressed("cancel_action") and game.mode[-1]==self:
		self.windup()
		
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	
	

#add remaining features later for clarity
func _on_button_message(val:String)->void:
	for i in range(game.mode.size()-1,-1,-1):
		if game.mode[i] == self:
			break
		else:
			game.mode[i].windup()
	match val:
		"move":
			var move_mode = game.move_mode_scene.instantiate()
			move_mode.setup(game,map,cursor,hud,props)
		"cast":
			var cast_mode = game.cast_mode_scene.instantiate()
			cast_mode.setup(game,map,cursor,hud,props)			
		"move grid":
			var display_grid_mode = game.display_grid_mode_scene.instantiate()
			display_grid_mode.setup(game,map,cursor,hud,[props[0],"move"])
		"vision grid":
			var display_grid_mode = game.display_grid_mode_scene.instantiate()
			display_grid_mode.setup(game,map,cursor,hud,[props[0],"vision"])
func windup():
		hud.clear_command_display()
		hud.clear_stats_display()
		hud.clear_inventory_display()
		hud.internal_stats={}
		super.windup()
		
