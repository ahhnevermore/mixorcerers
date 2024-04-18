class_name Unit
extends  Area2D

var initial_stats = {'move':5,
			'vision':5,
			'health':100}
var modified_stats = initial_stats.duplicate(true)

func resolve_cast(spell:Spell,terrain_stats):
	if spell.dmg_dist == Spell.DMG_Distribution.CLEAN:	#damage distribution will have damage varying across the grid
			#Calculate dmg
			var damage = (spell.fire_dmg * (1+terrain_stats['fire_affin']) +
						spell.water_dmg * (1+terrain_stats['water_affin']) +
						spell.earth_dmg * (1+terrain_stats['earth_affin']) +
						spell.air_dmg * (1+terrain_stats['air_affin'])
			)
			modified_stats['health'] -= damage
			
