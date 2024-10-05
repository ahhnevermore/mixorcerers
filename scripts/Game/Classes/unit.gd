class_name Unit
extends  Area2D
var game:Game
var map:Map
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
func _ready():
	game=get_parent()
	map=get_parent().get_node("Map")
	
func damage_trigger(damage)->Array:
	var on_dmg_grimoires=[]
	var health_remaining_percentage = (1 - (damage/ modified_stats['health'])) * 100
	for item in inventory:
		if item is Grimoire and item.type == Grimoire.Grimoire_Type.ON_DMG and item.value > health_remaining_percentage:
			on_dmg_grimoires.append(item)
	
	on_dmg_grimoires.sort_custom(func(a,b):return a.value > b.value)
	return on_dmg_grimoires	

func terrain_diff(terr1,terr2):
	var xdiff = map.terrains[terr1]['elevation']-map.terrains[terr2]['elevation']
	var ydiff = map.terrains[terr1]['moisture']-map.terrains[terr2]['moisture']
	var quadrant
	if xdiff > 0:
		if ydiff>0:
			quadrant = 'all'
		elif ydiff< 0:
			quadrant = 'cups'
		else:
			quadrant = "x+"
	elif xdiff < 0:
		if ydiff > 0 :
			quadrant = "silver"
		elif ydiff<0:
			quadrant="tea"
		else:
			quadrant= "x-"
	else:
		if ydiff>0:
			quadrant = 'y+'
		elif ydiff< 0:
			quadrant = 'y-'
		else:
			quadrant = "dead-centre"
	return [xdiff+ydiff,quadrant]
	
func terrain_trigger(new_terrain,unit_terrain)->Array:
	var on_terrain_grimoires =[]
	var new_terrain_diff = terrain_diff(new_terrain,unit_terrain)
	for item in inventory:
		if item is Grimoire and item.type == Grimoire.Grimoire_Type.ON_TERRAIN_CHANGE:
			var grimoire_terrain_diff = terrain_diff(item.value,unit_terrain)
			match grimoire_terrain_diff[1]:
				'dead-centre':
					on_terrain_grimoires.push_front([item,grimoire_terrain_diff])
				_:
					if grimoire_terrain_diff[1] == new_terrain_diff[1] and grimoire_terrain_diff[0] <= new_terrain_diff[0]:
						if on_terrain_grimoires:
							for i in range(len(on_terrain_grimoires)):
								if grimoire_terrain_diff[0] > on_terrain_grimoires[i][1][0]:
									if i == len(on_terrain_grimoires) - 1:
										on_terrain_grimoires.append([item,grimoire_terrain_diff])
									else:
										continue
								else:#termination
									on_terrain_grimoires.insert(i,[item,grimoire_terrain_diff])
						else:
							on_terrain_grimoires.append([item,grimoire_terrain_diff])	
				
	return on_terrain_grimoires.map(func(a):return a[0])

