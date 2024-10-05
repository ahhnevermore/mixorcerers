class_name DisplayGridMode
extends Mode

var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		match props[1]:
			'vision':
				grid = map.gen_vision_grid(props[0])
			'move':
				grid = map.gen_move_grid(props[0])
		map.display_grid(grid,props[1])

	if Input.is_action_just_pressed('cancel_action'):
		
		windup()

func windup()->void:
	map.clear_grid(grid,props[1])
	super()
