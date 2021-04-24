extends Node

func calculate_damage(damage, target_armor, target_resists):
	randomize()
	var new_damage = {}
	if damage["physical_damage"] != 0:
		 new_damage.physical_damage = float(damage["physical_damage"] * damage["physical_damage"] * 10) / (target_armor + 10 * damage["physical_damage"])
	else:
		 new_damage.physical_damage = 0
	new_damage.fire_damage = damage["fire_damage"] * (1 - target_resists["fire_resistance"])
	new_damage.ice_damage = damage["ice_damage"] * (1 - target_resists["ice_resistance"])
	new_damage.lightning_damage = damage["lightning_damage"] * (1 - target_resists["lightning_resistance"])
	
	var crit_roll = randf()
	if crit_roll < PlayerStats.active_stats["critical_strike_chance"]:
		print("Crit")
		for damage_type in new_damage:
			new_damage[damage_type] *= PlayerStats.active_stats["critical_strike_multiplier"]
	return new_damage

func calculate_total_damage(damage, target_armor, target_resists):
	var new_damage = calculate_damage(damage, target_armor, target_resists)
	var total_damage = 0
	for damage_type in new_damage:
		total_damage += new_damage[damage_type]
	return total_damage
