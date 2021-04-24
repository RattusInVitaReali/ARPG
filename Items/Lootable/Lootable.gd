extends Node2D

const FrameCommon = preload("res://UI Images/Frame_Common.png")
const FrameUncommon = preload("res://UI Images/Frame_Uncommon.png")
const FrameRare = preload("res://UI Images/Frame_Rare.png")
const FrameEpic = preload("res://UI Images/Frame_Epic.png")
const FrameLegendary = preload("res://UI Images/Frame_Legendary.png")

var item
var item_affixes

func generate_lootable():
	var rarity = item.item_rarity
	update_frame(rarity)
	var texture_path = "res://ImageResources/" + item.item_type + "/" + item.item_ID + ".png"
	update_image(texture_path)
	var quantity = item.quantity
	update_quantity(quantity)
	if !item.stackable:
		$Tooltip.update_name_and_type(item.item_rarity + " " + item.item_subtype, item.item_type)
	else:
		$Tooltip.update_name_and_type(item.item_name, item.item_type)

func update_frame(rarity):
	match rarity:
		"Common": 
			$RarityBorder.texture = FrameCommon
		"Uncommon":
			$RarityBorder.texture = FrameUncommon
		"Rare":
			$RarityBorder.texture = FrameRare
		"Epic":
			$RarityBorder.texture = FrameEpic
		"Legendary":
			$RarityBorder.texture = FrameLegendary

func update_image(image_path):
	var image = load(image_path)
	$Item.texture = image

func update_quantity(quantity):
	if quantity == 1:
		$Quantity.text = ""
	else:
		$Quantity.text = str(quantity)

func loot():
	PlayerStats.add_item_to_inventory(item)
	queue_free()


func _on_Area2D_body_entered(_body):
	loot()


func _on_Area2D_mouse_entered():
	$Tooltip.show()


func _on_Area2D_mouse_exited():
	$Tooltip.hide()
