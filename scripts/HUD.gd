extends Control

var UIButton_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	UIButton_scene = load("res://scenes/uibutton.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func terrain_display(terrain):
	$Terrain.text = terrain
	$Terrain.show()

func select_display(list,mode_node):
	for obj in list:
		var button = UIButton_scene.instantiate()
		button.setup(obj,mode_node)
		
		$Commands.add_child(button)
		
func clear_command_display():
	for item in $Commands.get_children():
		$Commands.remove_child(item)
		item.queue_free()		
		
