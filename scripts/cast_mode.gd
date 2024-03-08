extends Mode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	hud.clear_inventory_display()
	hud.inventory_display(props[0].inventory,self)

func windup():
	hud.clear_inventory_display()
	hud.inventory_display_uninteractive(props[0].inventory)
	super.windup()

func _on_button_message(val):
	print(val)
