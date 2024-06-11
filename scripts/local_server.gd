class_name LocalServer
extends Node

const DEFAULT_PORT = 37568

var server
var ip_addr = ""

func _ready():
	for ip in IP.get_local_addresses():
		pass
