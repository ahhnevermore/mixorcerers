extends Camera2D

var cursor:Cursor
var map:Map
# Called when the node enters the scene tree for the first time.
func _ready():
	cursor = get_parent().get_node('Cursor')
	map = get_parent().get_node('Map')
	position=cursor.position
	limit_left = -50
	limit_top = -50
	@warning_ignore("narrowing_conversion")
	limit_bottom = map.map_to_local(Vector2i(map.xw,map.yw)).y +50
	@warning_ignore("narrowing_conversion")
	limit_right = map.map_to_local(Vector2i(map.xw,map.yw)).x +50
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cursor_changed():
	
	var centre = get_screen_center_position()
	
	if (
		(abs(centre.x - cursor.cursor_tile.x)  > int((abs(centre.x - limit_left) *2)/3)) or
		(abs(centre.x - cursor.cursor_tile.x)  > int((abs(centre.x - limit_right) *2)/3)) or
		(abs(centre.y - cursor.cursor_tile.y)  > int((abs(centre.y - limit_top) *2)/3)) or
		(abs(centre.y - cursor.cursor_tile.y)  > int((abs(centre.y - limit_bottom) *2)/3))
	):
		position = cursor.position
