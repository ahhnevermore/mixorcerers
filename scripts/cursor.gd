extends Area2D

var Map
var cursor_active=true
# Called when the node enters the scene tree for the first time.
func _ready():
	Map=get_parent().get_node("Map")
	position= Map.map_to_local(Map.map_file["player1_start_position"])
	$RepeatDelay.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var change = Vector2i.ZERO
	if cursor_active:
		cursor_active= false
		if Input.is_action_pressed("cursor_down"):
			change.y+=1
		if Input.is_action_pressed("cursor_up"):
			change.y-=1
		if Input.is_action_pressed("cursor_left"):
			change.x-=1
		if Input.is_action_pressed("cursor_right"):
			change.x+=1
	
	var final=Map.local_to_map(position)+change
	if final.x< Map.xw and final.y< Map.yw and final.x>=0 and final.y>=0:
		position=Map.map_to_local(final)


func _on_repeat_delay_timeout():
	cursor_active=true
