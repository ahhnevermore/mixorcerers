extends Node

const DEFAULT_PORT = 37568
const MAX_CLIENTS = 20

var server
var client

var ip_addr = ""

func _ready():
	for ip in IP.get_local_addresses():
		pass
