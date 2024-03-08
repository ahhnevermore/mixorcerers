extends Mode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not freeze_process:
		if cursor.get_overlapping_areas():
			freeze_process = true
			hud.command_display(cursor.get_overlapping_areas(),self)
		else:
			self.windup()
	
	if Input.is_action_just_pressed("cancel_action"):
		self.windup()
		


func _on_button_message(val)->void:
	cursor.get_child(2).start()
	var selected_base_mode = game.base_mode_scene.instantiate()
	selected_base_mode.setup(game,map,cursor,hud,[val])
	self.windup()

func windup()->void:
	hud.clear_command_display()
	super.windup()
