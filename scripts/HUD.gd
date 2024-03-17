class_name HUD
extends CanvasLayer

var UIButton_scene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	UIButton_scene = load("res://scenes/uibutton.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func terrain_display(terrain:String)->void:
	$Div/Terrain.text = terrain
	$Div/Terrain.show()

func command_display(list:Array,mode_node:Mode)->void:
	for obj in list:
		var button = UIButton_scene.instantiate()
		button.setup(obj,mode_node)
		$Div/Commands.add_child(button)
		
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
				+"Health: " + str(internal_stats['health'])+"\n"
	)
	
func inventory_display_uninteractive(list:Array)->void:
	for i in range(list.size()):
		if i < 6:
			var slot = $Div/Inventory.get_child(i)
			var label = Label.new()
			label.text=list[i].alias
			slot.add_child(label)

func inventory_display(list:Array,mode_node:Mode)->void:
	for i in range(list.size()):
		if i < 6:
			var slot = $Div/Inventory.get_child(i)
			if list[i].castable:
				
				var button = UIButton_scene.instantiate()
				button.setup(list[i],mode_node)
				slot.add_child(button)
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
