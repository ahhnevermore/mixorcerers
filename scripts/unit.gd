class_name Unit
extends  Area2D

var initial_stats = {'move':5,
			'vision':5,
			'health':100,
			'max_health':120}
var modified_stats = initial_stats.duplicate(true)
var xy:Vector2i
var inventory=[
	null,null,null,null,
	null,null,null,null
	]

func damage_trigger(damage)->Array:
	var on_dmg_grimoires=[]
	var health_remaining_percentage = (1 - (damage/ modified_stats['health'])) * 100
	for item in inventory:
		if item is Grimoire and item.type == Grimoire.Grimoire_Type.ON_DMG and item.value > health_remaining_percentage:
			on_dmg_grimoires.append(item)
	return on_dmg_grimoires	


