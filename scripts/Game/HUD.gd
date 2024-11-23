class_name HUD
extends CanvasLayer

var inventory_max_size =8
signal end_turn

var endturn_state := "unhovered"
var turn_time 
var is_myturn
# Called when the node enters the scene tree for the first time.
func _ready():
	$Div/EndTurn.pressed.connect(_on_endturn_pressed)
	$Div/EndTurn.mouse_entered.connect(_on_endturn_mouse_entered)
	$Div/EndTurn.mouse_exited.connect(_on_endturn_mouse_exited)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func terrain_display(terrain:String,cursor:Vector2i)->void:
	$Div/Terrain.text = (
		terrain + "\n"
		+ str(cursor.x)+"," + str(cursor.y)
	)
	$Div/Terrain.show()

func command_display(list:Array,mode_node:Mode)->void:
	for obj in list:
		$Div/Commands.add_child(UIButton.new(obj,mode_node))
		
func clear_command_display()->void:
	for item in $Div/Commands.get_children():
		item.queue_free()		

var internal_stats={}
#stats is a 2D array with format [stat,value]
func stats_display(stats_list:Array):
	for stat in stats_list:
		internal_stats[stat[0]] = stat[1]
	$Div/Stats.text=("  Move: " + str(internal_stats['move'])+"\n"
				+"Vision: " + str(internal_stats['vision'])+"\n"
				+"Health: " + str(internal_stats['health'])+"/"+str(internal_stats['max_health'])+"\n"
	)
	
func inventory_display_uninteractive(list:Array)->void:
	for i in range(inventory_max_size):
		if list[i] :
			var slot = $Div/Inventory.get_child(i)
			var label = Label.new()
			label.text=list[i].alias
			slot.add_child(label)

func inventory_display(list:Array,mode_node:Mode)->void:
	for i in range(inventory_max_size):
		if list[i] :
			var slot = $Div/Inventory.get_child(i)
			if list[i].castable:
				slot.add_child(UIButton.new(list[i],mode_node))
			else:
				var label = Label.new()
				label.text=list[i].alias
				slot.add_child(label)

func clear_inventory_display()->void:
	for slot in $Div/Inventory.get_children():
		for item in slot.get_children():
			item.queue_free()
		
func clear_stats_display()->void:
	$Div/Stats.text=""

func _on_endturn_pressed():
	if is_myturn:
		end_turn.emit()

func _on_endturn_mouse_entered():
	endturn_state="hovered"
	endturn_display()

func _on_endturn_mouse_exited():
	endturn_state = "unhovered"
	endturn_display()
	
func endturn_display():
	if is_myturn: 
		if endturn_state == "hovered":
			$Div/EndTurn.text = "Submit Turn"
		else:
			$Div/EndTurn.text = turn_time
	else:
		$Div/EndTurn.text = "Enemy Turn"
func turn_timer(arg):
	if arg:
		turn_time = str(arg)
		endturn_display()
		get_tree().create_timer(1.).timeout.connect(turn_timer.bind(arg-1))
	else:
		turn_time = "TIMES UP!"
		endturn_display()


func _on_game_turn(_turn_number,arg_ismyturn) -> void:
	
	is_myturn = arg_ismyturn
	if is_myturn:
		turn_timer(120)
	endturn_display()
