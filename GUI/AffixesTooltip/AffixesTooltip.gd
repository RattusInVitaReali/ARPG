extends Control

const AffixLabel = preload("res://GUI/AffixLabel.tscn")

func show():
	visible = true

func hide():
	visible = false

func initialize(itemName, itemType, affixes):
	for child in $Background/VBoxContainer/Affixes.get_children():
		child.queue_free()
	$Background/VBoxContainer/Name.text = itemName
	match itemType:
		"Weapons":
			$Background/VBoxContainer/Type.text = "Weapon"
		"Armor":
			$Background/VBoxContainer/Type.text = "Armor"
		"CraftingMaterials":
			$Background/VBoxContainer/Type.text = "Crafting"
	for affix in affixes:
		var label = AffixLabel.instance()
#		label.text = "%s: %s" % [affix.name, affix.value]
		var value = str(affix.value)
		if affix.show_as_percent: 
			value = str(affix.value * 100) + "%"
		var text = "Text not found? " + affix.name
		match affix.name:
			"Added Accuracy Rating":
				text = "+" + value + " to Accuracy Rating"
			"Added Armor":
				text = "+" + value + " Armor"
			"Added Physical Damage":
				text = "+" + value + " Physical Damage"
			"Base Physical Damage":
				text = "+" + value + " Base Physical Damage"
			"Critical Strike Multiplier":
				text = "+" + value + " to Critical Strike Multiplier"
			"Dexterity":
				text = "+" + value + " Dexterity"
			"Increased Area of Effect": 
				text = value + " Increased Area of Effect"
			"Increased Armor":
				text = value + " Increased Armor"
			"Increased Attack Speed": 
				text = value + " Increased Attack Speed"
			"Increased Critical Strike Chance":
				text = value + " Increased Critical Strike Chance"
			"Increased Movement Speed": 
				text = value + " Increased Movement Speed"
			"Increased Physical Damage":
				text = value + " Increased Physical Damage"
			"Intelligence":
				text = "+" + value + " Intelligence"
			"Strength":
				text = "+" + value + " Strength"
			"Added Fire Damage":
				text = "+" + value + " Fire Damage"
			"Added Ice Damage":
				text = "+" + value + " Ice Damage"
			"Added Lightning Damage":
				text = "+" + value + " Lightning Damage"
			"Increased Fire Damage":
				text = value + " Increased Fire Damage"
			"Increased Ice Damage":
				text = value + " Increased Ice Damage"
			"Increased Lightning Damage":
				text = value + " Increased Lightning Damage"
			"Increased Elemental Damage":
				text = value + " Increased Elemental Damage"
			"Additional Projectiles":
				text = "Skills fire " + value + " additional Projectiles"
		label.text = text
		$Background/VBoxContainer/Affixes.add_child(label)
