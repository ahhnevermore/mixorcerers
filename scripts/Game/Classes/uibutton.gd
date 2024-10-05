class_name UIButton
extends Button

signal message
var val=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _init(arg,mode_node):
	if arg is Node:
		self.text= arg.alias
	else:
		self.text = arg
	val = arg
	pressed.connect(_on_pressed)
	message.connect(mode_node._on_button_message)

func _on_pressed():
	release_focus()
	message.emit(val)
