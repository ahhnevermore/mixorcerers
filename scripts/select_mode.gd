class_name SelectMode
extends Mode


# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.get_child(2).stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		var raw_areas_list = cursor.get_overlapping_areas()
		var areas_list =[]
		for area in raw_areas_list:
			if area.is_visible():
				areas_list.append(area)
		if areas_list:
			if areas_list.size() == 1:
					_on_button_message(areas_list[0])
			else:
				hud.command_display(areas_list,self)
			update = false
		else:
			windup()
	
	if Input.is_action_just_pressed("cancel_action"):
		windup()
		


func _on_button_message(val)->void:
	game.add_child(BaseMode.new(game,map,cursor,hud,[val]))
	windup()

func windup()->void:
	cursor.get_child(2).start()
	hud.clear_command_display()
	super()
