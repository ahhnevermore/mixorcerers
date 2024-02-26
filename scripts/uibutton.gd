extends Button

signal message
var val=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setup(arg,mode_node):
	if arg is Node:
		self.text= arg.name
	else:
		self.text = arg
	val = arg
	message.connect(mode_node._on_button_message)

func _on_pressed():
	message.emit(val)
