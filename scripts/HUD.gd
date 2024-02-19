extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func terrain_display(terrain):
	$Terrain.text = terrain
	$Terrain.show()

func menu_display(list):
	for obj in list:
		var button = Button.new()
		button.text = obj.name
		$Commands.add_child(button)
		
