class_name Cursor
extends Area2D

var map :Map
var cursor_active:bool = true
var cursor_tile: Vector2i 
var freeze_cursor:bool = false
signal cursor_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	map=get_parent().get_node("Map")
	cursor_tile= map.map_file[map.player+"_start_position"]
	position= map.map_to_local(cursor_tile)
	$RepeatDelay.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var change = Vector2i.ZERO
	if cursor_active :
		cursor_active= false
		if Input.is_action_pressed("cursor_down"):
			change.y+=1
		if Input.is_action_pressed("cursor_up"):
			change.y-=1
		if Input.is_action_pressed("cursor_left"):
			change.x-=1
		if Input.is_action_pressed("cursor_right"):
			change.x+=1

	if change:
		var final=map.local_to_map(position)+change
		if final.x< map.xw and final.y< map.yw and final.x>=0 and final.y>=0:
			position=map.map_to_local(final)
			cursor_tile = final
			cursor_changed.emit()

func update(xy:Vector2i):
	position = map.map_to_local(xy)
	cursor_tile = xy
	cursor_changed.emit()

func _on_repeat_delay_timeout()->void:
	cursor_active=true


func calc_relative_cursor(unit_xy,precast_position:Dictionary):
	var res
	if precast_position.has('origin'):
		res = Vector2i(
							precast_position['position'].x - precast_position['origin'].x + unit_xy.x,
							precast_position['position'].y - precast_position['origin'].y + unit_xy.y
						)
		if unit_xy.y % 2 != res.y % 2 && precast_position['origin'].y %2 != unit_xy.y %2:#line difference
			if res.y % 2: 
				res.x += 1
			else: #even line
				res.x -= 1
	else:
		res = precast_position['position']
	return res
