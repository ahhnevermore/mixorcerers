extends Camera2D

var cursor:Cursor
var map:Map
#this variable is used to move camera when the cursor tile is is a bit too far off the middle of the screen
# size/2 * 2/3
var camera_move_threshold

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor = get_parent().get_node('Cursor')
	map = get_parent().get_node('Map')
	position=cursor.position
	limit_left = -20
	limit_top = -40
	@warning_ignore("narrowing_conversion")
	limit_bottom = map.map_to_local(Vector2i(map.xw,map.yw)).y +100
	@warning_ignore("narrowing_conversion")
	limit_right = map.map_to_local(Vector2i(map.xw,map.yw)).x +20
	camera_move_threshold=(get_viewport().get_visible_rect().size/4)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cursor_changed():
	
	if (
		(abs(position.x - cursor.position.x)  > camera_move_threshold.x) or 
		(abs(position.y - cursor.position.y)  > camera_move_threshold.y)
		):
		var tween = create_tween()
		tween.tween_property(self,"position",cursor.position,0.3)
