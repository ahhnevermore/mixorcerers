extends Node

var replay = false
var mode = []
var select_scene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	select_scene = load("res://scenes/select_mode.tscn")
	$Map.gen_map()
	$Player.display_vision()
	#$Player1.display_move_grid()
	_on_cursor_changed()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	if not mode and Input.is_action_just_pressed("select_confirm"):
		print("clicked")
		mode.append("select")
		var select_mode = select_scene.instantiate()
		select_mode.setup(self,$Map,$Cursor,$HUD)
		add_child(select_mode)



#TODO
#Path finding algorithm
#Spells
#add spell prop to dict
#All terrain modifications have to set the cache of the terrain to null


func _on_cursor_changed():
	$HUD.terrain_display($Map.get_terrain($Map.get_tile($Cursor.cursor_tile)))
