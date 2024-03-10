extends Mode

#Invariant - there should be props[1] for anything to be cost
var cast_range_grid
var cast_grid
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
					
			
	
func setup(arg_game:Game,arg_map:Map,arg_cursor:Cursor,arg_hud:HUD,arg_props:Array)->void:
	super.setup(arg_game,arg_map,arg_cursor,arg_hud,arg_props)
	hud.clear_inventory_display()
	hud.inventory_display(props[0].inventory,self)
	update=false
	cursor.cursor_changed.connect(_on_cursor_changed)
	
func _on_cursor_changed():
	if props.size()> 1 and props[1] is Spell:
		match props[1].cast_shape:
			Spell.cast_shapes.CIRCLE:
				cast_grid = MapGrid.new(map.field_of_prop(cursor.cursor_tile,
					"cast_cost",props[1].cast_range,[],0,false))
				
				
		

func windup():
	map.clear_grid(cast_grid,"cast")
	hud.clear_inventory_display()
	hud.inventory_display_uninteractive(props[0].inventory)
	super.windup()

func _on_button_message(val):
	if props.size()>1:
		props=[props[0]]
	props.append(val)
	update = true 
