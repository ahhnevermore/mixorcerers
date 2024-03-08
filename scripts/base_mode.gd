extends Mode
#EXPECTS PROPS to be just 1 unit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not freeze_process and props[0]:
		freeze_process= true
		hud.command_display(props[0].commands,self)
		hud.inventory_display_uninteractive(props[0].inventory)
	if Input.is_action_just_pressed("cancel_action") and game.mode[-1]==self:
		self.windup()
		


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

func windup():
		hud.clear_command_display()
		hud.clear_stats_display()
		hud.clear_inventory_display()
		super.windup()
		
