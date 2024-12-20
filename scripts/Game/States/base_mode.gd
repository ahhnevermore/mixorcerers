class_name BaseMode
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
		if game.is_myturn:
			hud.command_display(props[0].commands,self)
		hud.inventory_display_uninteractive(props[0].inventory)
	if Input.is_action_just_pressed("select_confirm") and game.mode[-1]==self:
		game.add_child(SelectMode.new(game,map,cursor,hud,[]))
		windup()
		
	if Input.is_action_just_pressed("cancel_action") and game.mode[-1]==self:
		windup()
		
func _init(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	
	

#add remaining features later for clarity
func _on_button_message(val:String)->void:
	for i in range(game.mode.size()-1,-1,-1):
		if game.mode[i] == self:
			break
		else:
			game.mode[i].windup()
	match val:
		"move":
			game.add_child(MoveMode.new(game,map,cursor,hud,props))
		"cast":
			game.add_child(CastMode.new(game,map,cursor,hud,props))
		"move grid":
			game.add_child(MoveMode.new(game,map,cursor,hud,[props[0],'move']))
		"vision grid":
			game.add_child(DisplayGridMode.new(game,map,cursor,hud,[props[0],'vision']))
		"mix":
			var mix_display = game.mix_display_scene.instantiate()
			mix_display.setup(game,map,cursor,hud,props)
			
func windup():
		hud.clear_command_display()
		hud.clear_stats_display()
		hud.clear_inventory_display()
		hud.internal_stats={}
		super()
		
