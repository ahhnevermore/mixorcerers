extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


class Terrain:
	var elevation
	var moisture
	var fire_affinity
	var water_affinity
	var earth_affinity
	var wind_affinity
	
	func _init(arg_elevation, arg_moisture, arg_faffinity,arg_waaffinity,arg_eaffinity,arg_wiaffinity):
		self.elevation = arg_elevation
		self.moisture = arg_moisture
		self.fire_affinity = arg_faffinity
		self.water_affinity = arg_waaffinity
		self.earth_affinity = arg_eaffinity
		self.wind_affinity = arg_wiaffinity
