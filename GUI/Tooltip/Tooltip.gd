extends Control

func show():
	visible = true

func hide():
	visible = false


func update_name_and_type(new_name, new_type):
	$Background/VBoxContainer/ItemName.text = new_name
	match new_type:
		"Weapons":
			$Background/VBoxContainer/ItemType.text = "Weapon"
		"Armor":
			$Background/VBoxContainer/ItemType.text = "Armor"
		"CraftingMaterials":
			$Background/VBoxContainer/ItemType.text = "Crafting"
