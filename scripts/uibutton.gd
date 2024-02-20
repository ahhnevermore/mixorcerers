extends Button

signal message
var val=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(obj,mode_node):
	self.text= obj.name
	val = obj
	message.connect(mode_node._on_button_message)

func _on_pressed():
	message.emit(val)
