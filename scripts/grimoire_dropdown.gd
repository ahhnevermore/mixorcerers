extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	for type in Grimoire.Grimoire_Type:
		add_item(type)
func set_parent(arg_parent):
	self.item_selected.connect(arg_parent._on_grimoire_dropdown_selected)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
