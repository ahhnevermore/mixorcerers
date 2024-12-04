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

func add_item(xs:Array,item,orbs,should_log:=true):
	var action=[]
	if item is Spell:
		if xs[0]:
			if xs[1]:
				var outgoing_spell:Spell = xs[1]
				if outgoing_spell.alias == item.alias and Game.orbs_operation(outgoing_spell.real_cost,"lt",item.real_cost):
					Game.orbs_operation(orbs,"add",item.real_cost,)
					xs[1] = xs[0]
					xs[0] = outgoing_spell
				else:
					Game.orbs_operation(orbs,"add",outgoing_spell.real_cost,)
					xs[1] =xs[0]
					xs[0]=item
					action.append(['create',item])
					action.append(["remove",outgoing_spell])
			else:
				xs[1] = xs[0]
				xs[0] = item
				action.append(['create',item]) 
		else:
			xs[0]= item
			action.append(["create",item])
	else:
		var replace_index = false
		var placed = false
		for i in range(2,8):
			if not xs[i]:
				xs[i] = item
				placed = true
				action.append(["create",item])
				break
			elif xs[i] is Grimoire and not replace_index:
				replace_index = i
		if not placed:
			if replace_index:
				var outgoing_item = xs[replace_index]
				if outgoing_item.alias == item.alias and Game.orbs_operation(outgoing_item.spell.real_cost,"lt",item.spell.real_cost):
					Game.orbs_operation(orbs,"add",item.spell.real_cost,)
					xs[replace_index] = outgoing_item
				else:
					Game.orbs_operation(orbs,"add",outgoing_item.spell.real_cost,)
					xs[replace_index] = item
					action.append(["create",item])
					action.append(["remove",outgoing_item])
				
			else:
				var outgoing_item = xs[2]
				xs[2] = item
				action.append(["create",item])
				action.append( ["remove",outgoing_item])
	if should_log:
		for x in action:
			game.commit_action(self,x[0],x[1])

func damage_trigger(damage)->Array:
	var on_dmg_grimoires=[]
	var health_remaining_percentage = (1 - (damage/ modified_stats['health'])) * 100
	for item in inventory:
		if item is Grimoire and item.type == Grimoire.Grimoire_Type.ON_DMG and item.value > health_remaining_percentage:
			on_dmg_grimoires.append(item)
	
	on_dmg_grimoires.sort_custom(func(a,b):return a.value > b.value)
	return on_dmg_grimoires	

#TODO move this Map
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
