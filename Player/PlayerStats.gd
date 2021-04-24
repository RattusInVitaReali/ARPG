extends Node

const ItemStats = preload("res://Utilities/Items/ItemStats.tscn")

signal update_slot

var gold = 0
var inventory_data = {1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {}}
var current_bag = 1
var equipment = {"Head": null, "Shoulders": null, "Chest": null, "Hands": null, "Legs": null, "Feet": null,
				 "Amulet": null, "Back": null, "Belt": null, "Wrists": null, "Ring1": null, "Ring2": null,
				 "Trinket1": null, "Trinket2": null, "Artifact": null, "Weapon1": null, "Weapon2": null}

const exp_per_level = {1: 0, 2: 20, 3: 50, 4: 100, 5: 200, 6: 350, 7: 600, 101: INF}

var experience = 0
var level = 1 
var stat_points_per_level = 3
var stat_points_available = 0
var stat_points_used = 0


#ACTIVE
var acceleration = 0
var max_speed = 0
var friction = 0

var active_stats = {"accuracy": 0, "physical_damage": 0, "fire_damage": 0, "ice_damage": 0, "lightning_damage": 0,
					 "critical_strike_chance": 0, "critical_strike_multiplier": 0, "attack_speed": 0, "aoe": 0,
					 "armor": 0, "strength": 0, "dexterity": 0, "intelligence": 0, "movement_speed": 0, "additional_projectiles": 0}

var allocated_stats = {"base_physical_damage": 0, "base_attack_speed": 0, "base_critical_strike_chance": 0, "base_fire_damage": 0,
					 "base_ice_damage": 0, "base_lightning_damage": 0, "total_critical_strike_multiplier": 0, "base_aoe": 0}

#STATS
var base_physical_damage_stat = 0.05
var base_attack_speed_stat = 0.1
var base_critical_strike_chance_stat = 0.01
var base_aoe_stat = 0.05
var base_fire_damage_stat = 0.05
var base_ice_damage_stat = 0.05
var base_lightning_damage_stat = 0.05
var total_critical_strike_multiplier_stat = 0.1

#ORIGINAL VALUE
var original_acceleration = 500
var original_max_speed = 120
var original_friction = 500

var original_armor = 20
var original_accuracy_rating = 100
var original_physical_damage = 1
var original_critical_strike_chance = 0.1
var original_critical_strike_multiplier = 2
var original_attack_speed = 1
var original_aoe = 1
var original_fire_damage = 0
var original_ice_damage = 0
var original_lightning_damage = 0


#BASE VALUE
var base_acceleration = 500
var base_max_speed = 120
var base_friction = 500

var base_armor = 20
var base_accuracy_rating = 100
var base_physical_damage = 1
var base_critical_strike_chance = 0.1
var base_critical_strike_multiplier = 2
var base_attack_speed = 1
var base_aoe = 1
var base_fire_damage = 0
var base_ice_damage = 0
var base_lightning_damage = 0

# + VALUE
var added_armor = 0
var added_accuracy_rating = 0
var added_physical_damage = 0
var added_fire_damage = 0
var added_ice_damage = 0
var added_lightning_damage = 0
var added_critical_strike_chance = 0
var added_critical_strike_multiplier = 0
var added_strength = 0
var added_dexterity = 0
var added_intelligence = 0
var added_additional_projectiles = 0
var increased_critical_strike_chance = 0
var increased_armor = 0
var increased_movement_speed = 0
var increased_aoe = 0
var increased_attack_speed = 0
var increased_physical_damage = 0
var increased_fire_damage = 0
var increased_ice_damage = 0
var increased_lightning_damage = 0
var increased_elemental_damage = 0

var bags_equipped = 7

func equip_item(item):
	var slot_name 
	match item.item_type:
		"Weapons":
			slot_name = "Weapon1"
		"Armor":
			match item.item_subtype:
				"Head":
					slot_name = "Head"
				"Feet":
					slot_name = "Feet"
				"Hands":
					slot_name = "Hands"
				"Belt":
					slot_name = "Belt"
				"Chest":
					slot_name = "Chest"
				"Legs":
					slot_name = "Legs"
				"Back":
					slot_name = "Back"
					
	if equipment[slot_name] != null:
		unequip_item(equipment[slot_name])
	equipment[slot_name] = item
	emit_signal("update_slot", slot_name)
	apply_affixes(item, false)

func apply_affixes(item, negative):
	var affixes = item.get_node("ItemStats").affixes
	if negative:
		for affix in affixes:
			affix.value = -affix.value
	for affix in affixes:
		match affix.name:
			"Added Physical Damage":
				added_physical_damage += affix.value
			"Increased Physical Damage":
				increased_physical_damage += affix.value
			"Base Physical Damage":
				original_physical_damage = affix.value
			"Increased Critical Strike Chance":
				increased_critical_strike_chance += affix.value
			"Critical Strike Multiplier":
				added_critical_strike_multiplier += affix.value
			"Increased Movement Speed":
				increased_movement_speed += affix.value
			"Increased Area of Effect":
				increased_aoe += affix.value
			"Increased Attack Speed":
				increased_attack_speed += affix.value
			"Strength":
				added_strength += affix.value
			"Dexterity":
				added_dexterity += affix.value
			"Intelligence":
				added_intelligence += affix.value
			"Added Armor":
				added_armor += affix.value
			"Added Accuracy Rating":
				added_accuracy_rating += affix.value
			"Increased Armor":
				increased_armor += affix.value
			"Added Fire Damage":
				added_fire_damage += affix.value
			"Increased Fire Damage":
				increased_fire_damage += affix.value
			"Added Ice Damage":
				added_ice_damage += affix.value
			"Increased Ice Damage":
				increased_ice_damage += affix.value
			"Added Lightning Damage":
				added_lightning_damage += affix.value
			"Increased Lightning Damage":
				increased_lightning_damage += affix.value
			"Additional Projectiles":
				added_additional_projectiles += affix.value


	if negative:
		for affix in affixes:
			affix.value = -affix.value


func unequip_item(item):
	apply_affixes(item, true)
	add_item_to_inventory(item)


func check_empty_bag():
	var first_empty_bag = 0
	for bag_index in inventory_data:
		if !inventory_data[bag_index].has(24):
			first_empty_bag = bag_index
			break
		else:
			pass
	return first_empty_bag


func add_item_to_inventory(item):
	if item.stackable == true:
		match item.item_ID:
			"Gold":
				gold += item.quantity
	else:
		var empty_bag_index = check_empty_bag()
		for i in range(1, 25):
			if !inventory_data[empty_bag_index].has(i):
				inventory_data[empty_bag_index][i] = item
				emit_signal("update_slot", i)
				break


func add_experience(value):
	experience += value
	if experience >= exp_per_level[level + 1]:
		levelup()


func levelup():
	level += 1
	print("levelup " + str(level))
	stat_points_available += stat_points_per_level

func calculate_stats():
	#MOVEMENT SPEED
	max_speed = base_max_speed * (1 + increased_movement_speed)
	acceleration = base_acceleration * (1 + increased_movement_speed)
	friction = base_friction * (1 + increased_movement_speed)
	active_stats.movement_speed = max_speed
	#PHYSICAL DAMAGE
	base_physical_damage = original_physical_damage + added_physical_damage
	active_stats.physical_damage = base_physical_damage * (1 + increased_physical_damage) * (1 + base_physical_damage_stat * allocated_stats.base_physical_damage)
	#ELEMENTAL DAMAGE
	base_fire_damage = original_fire_damage + added_fire_damage
	active_stats.fire_damage = base_fire_damage * (1 + increased_fire_damage + increased_elemental_damage) * (1 + base_fire_damage_stat * allocated_stats.base_fire_damage)
	base_ice_damage = original_ice_damage + added_ice_damage
	active_stats.ice_damage = base_ice_damage * (1 + increased_ice_damage + increased_elemental_damage) * (1 + base_ice_damage_stat * allocated_stats.base_ice_damage)
	base_lightning_damage = original_lightning_damage + added_lightning_damage
	active_stats.lightning_damage = base_lightning_damage * (1 + increased_lightning_damage + increased_elemental_damage) * (1 + base_lightning_damage_stat * allocated_stats.base_lightning_damage)
	#CRITICAL
	base_critical_strike_chance = original_critical_strike_chance + base_critical_strike_chance_stat * allocated_stats.base_critical_strike_chance
	active_stats.critical_strike_chance = base_critical_strike_chance * (1 + increased_critical_strike_chance) + added_critical_strike_chance
	base_critical_strike_multiplier = original_critical_strike_multiplier + added_critical_strike_multiplier
	active_stats.critical_strike_multiplier = base_critical_strike_multiplier * (1 + total_critical_strike_multiplier_stat * allocated_stats.total_critical_strike_multiplier)
	#ATTACK SPEED
	base_attack_speed = original_attack_speed + base_attack_speed_stat * allocated_stats.base_attack_speed
	active_stats.attack_speed = base_attack_speed * (1 + increased_attack_speed)
	#AOE 
	base_aoe = original_aoe * (1 + base_aoe_stat * allocated_stats.base_aoe)
	active_stats.aoe = base_aoe * (1 + increased_aoe)
	#ARMOR
	base_armor = original_armor + added_armor
	active_stats.armor = base_armor * (1 + increased_armor)
	#ATTRIBUTES
	active_stats.strength = added_strength
	active_stats.dexterity = added_dexterity
	active_stats.intelligence = added_intelligence
	#PROJECTILES
	active_stats.additional_projectiles = added_additional_projectiles




















