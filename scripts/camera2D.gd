extends Camera2D

var cursor:Cursor
# Called when the node enters the scene tree for the first time.
func _ready():
	cursor = get_parent().get_node('Cursor')
	position=cursor.position
	self.limit_left = -150
	limit_top = -150
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cursor_changed():
	var centre = get_screen_center_position()
	if abs(centre.x - cursor.cursor_tile.x)  > int((abs(centre.x - limit_left) *2)/3) :
		position = cursor.position
