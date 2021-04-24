extends Node

const Item = preload("res://Utilities/Items/Item.tscn")
const Lootable = preload("res://Utilities/Items/Lootable.tscn")
const Affix = preload("res://Utilities/Items/Affixes/AffixScene.tscn")

func generate_loot(lootID):
	var lootDic = {}
	var droppableItems = ImportData.loot_data[lootID].DroppableItems
	for i in range (0, droppableItems):
		var chance = ImportData.loot_data[lootID]["Item" + str(i) + "Chance"]
		randomize()
		var percent = rand_range(0, 1)
		if percent <= chance:
			var loot = []
			var ID = ImportData.loot_data[lootID]["Item" + str(i) + "ID"]
			var item = Item.instance()
			item = generate_item(ID)
			var quantity = randi() % int((ImportData.loot_data[lootID]["Item" + str(i) + "MaxQ"]
									 - ImportData.loot_data[lootID]["Item" + str(i) + "MinQ"]) + 1) + ImportData.loot_data[lootID]["Item" + str(i) + "MinQ"]
			item.quantity = quantity
			loot.append(item)
			loot.append(quantity)
			lootDic[lootDic.size()] = loot
	return(lootDic)

func generate_item(ID):
	var item = Item.instance()
	item.item_ID = ID
	for type in ImportData.item_data:
		if ImportData.item_data[type].has(item.item_ID):
			item.item_type = type
			if ImportData.item_data[type][item.item_ID].has("ItemSubtype"):
				item.item_subtype = ImportData.item_data[type][item.item_ID].ItemSubtype
			item.item_name = ImportData.item_data[type][item.item_ID].ItemName
			item.name = item.item_name
			break
	match ImportData.item_data[item.item_type][item.item_ID].Stackable:
		"Yes":
			item.stackable = true
		"No":
			item.stackable = false
	item.generate_texture_path()
	if ImportData.item_data[item.item_type][item.item_ID].has("AffixGroup"):
		item.item_rarity = generate_rarity()
		var affix_count = 0
		match item.item_rarity:
			"Common":
				affix_count = randi() % 2 + 1
			"Uncommon":
				affix_count = randi() % 2 + 3
			"Rare":
				affix_count = randi() % 2 + 5
			"Epic":
				affix_count = 7
			"Legendary":
				affix_count = 8
		var affixGroup = ImportData.item_data[item.item_type][item.item_ID].AffixGroup
		generate_item_stats(item, affixGroup, affix_count)
		generate_item_name(item)
	return item

func generate_item_stats(item, AffixGroup, affixCount):
	var affixes = []
	var possible_affixes_strings = ImportData.affix_data[AffixGroup]
	for affix in possible_affixes_strings:
		var resource = load("res://Utilities/Items/Affixes/" + affix + ".tres")
		affixes.append(resource)
	item.possible_affixes = affixes
	var new_affixes = []
	for affix in item.possible_affixes:
		if affix.mandatory:
			var new_affix = Affix.instance()
			new_affix.initialize(affix.affix_name, generate_affix_value(affix), affix.show_as_percent)
			new_affixes.append(new_affix)
			item.possible_affixes.erase(affix)
	for _i in range(affixCount):
		var total_weight = 0
		for affix in item.possible_affixes:
			total_weight += affix.weight
		var roll = randi() % total_weight
		for affix in item.possible_affixes:
			roll -= affix.weight
			if roll <= affix.weight:
				var new_affix = Affix.instance()
				new_affix.initialize(affix.affix_name, generate_affix_value(affix), affix.show_as_percent)
				new_affixes.append(new_affix)
				item.possible_affixes.erase(affix)
				break
	item.get_node("ItemStats").affixes = new_affixes

func generate_item_name(item):
	var affix_count = item.get_node("ItemStats").affixes.size()
	match item.item_type:
		"Weapons":
			match item.item_subtype:
				"Sword":
					match affix_count:
						1:
							pass
						2:
							var roll = randi() % 2
							if roll == 0:
								item.item_name = generate_prefix(item) + " " + item.item_name
							else:
								 item.item_name = item.item_name + " " + generate_suffix(item)
						3, 4, 5:
							item.item_name = generate_prefix(item) + " " + item.item_name + " " + generate_suffix(item)
						6, 7:
							item.item_name = generate_cool_name(item)
						8, 9:
							item.item_name = generate_cool_name(item) + ", " + generate_cool_type() + " " + generate_suffix(item)
		"Armor":
			match item.item_subtype:
				"Chest":
					match affix_count:
						1:
							pass
						2, 3:
							var roll = randi() % 2
							if roll == 0:
								item.item_name = generate_prefix(item) + " " + item.item_name
							else:
								item.item_name = item.item_name + " " + generate_suffix(item)
						4, 5, 6:
							item.item_name = generate_prefix(item) + " " + item.item_name + " " + generate_suffix(item)
						7, 8, 9:
							item.item_name = generate_cool_name(item) + " " + generate_suffix(item)




func generate_prefix(item):
	randomize()
	var prefix
	match item.item_type:
		"Weapons":
			prefix = ImportData.WeaponPrefixes[randi() % ImportData.WeaponPrefixes.size()]
		"Armor":
			prefix = ImportData.ArmorPrefixes[randi() % ImportData.ArmorPrefixes.size()]
	return prefix

func generate_suffix(item):
	randomize()
	var suffix
	match item.item_type:
		"Weapons":
			suffix = ImportData.WeaponSuffixes[randi() % ImportData.WeaponSuffixes.size()]
		"Armor":
			suffix = "of " + ImportData.ArmorSuffixes[randi() % ImportData.ArmorSuffixes.size()]
	return suffix

func generate_cool_name(item):
	randomize()
	var cool_name
	match item.item_type:
		"Weapons":
			match item.item_subtype:
				"Sword":
					cool_name = ImportData.SwordNames.names[randi() % ImportData.SwordNames.names.size()]
		"Armor":
			match item.item_subtype:
				"Chest":
					cool_name = ImportData.ChestNames[randi() % ImportData.ChestNames.size()]
	return cool_name

func generate_cool_type():
	randomize()
	var cool_type = ImportData.SwordNames.types[randi() % ImportData.SwordNames.types.size()]
	return cool_type

func generate_rarity():
	var Floor = GameData.Floor
	var legendary = 0.0005 * Floor
	var epic = 0.0006 * Floor + 0.01
	var rare = 0.0009 * Floor + 0.03
	var uncommon = 0.0012 * Floor + 0.1
	
	var roll = rand_range(0, 1)
	if roll <= legendary:
		return "Legendary"
	if roll <= epic:
		return "Epic"
	if roll <= rare:
		return "Rare"
	if roll <= uncommon:
		return "Uncommon"
	else:
		return "Common"

func generate_affix_value(affix):
	var rounder
	if affix.integer:
		rounder = 1
	else:
		rounder = 0.01
	var value = stepify(rand_range(affix.min_value, affix.max_value), rounder)
	return value


func generate_lootables(loot, position):
	for i in range(0, loot.size()):
		randomize()
		var item = loot[i][0]
		var lootable = Lootable.instance()
		lootable.item = item
		lootable.generate_lootable()
		get_parent().add_child(lootable)
		lootable.global_position = position





















