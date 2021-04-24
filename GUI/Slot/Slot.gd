extends TextureRect

var Item

const FrameBase = preload("res://UI Images/Frame.png")

const FrameCommon = preload("res://UI Images/Frame_Common.png")
const FrameUncommon = preload("res://UI Images/Frame_Uncommon.png")
const FrameRare = preload("res://UI Images/Frame_Rare.png")
const FrameEpic = preload("res://UI Images/Frame_Epic.png")
const FrameLegendary = preload("res://UI Images/Frame_Legendary.png")

var has_item = false


func _process(_delta):
	if has_item:
		var position = get_viewport().get_mouse_position()
		$CanvasLayer/Tooltip.set_global_position(position)

func update_slot():
	if has_item:
		var item_texture = load(Item.texture_path)
		$Item.texture_normal = item_texture
		var item_quantity = Item.quantity
		if item_quantity != 1:
			$Quantity.text = str(item_quantity)
		var item_rarity = Item.item_rarity
		match item_rarity:
			"Common":
				texture = FrameCommon
			"Uncommon":
				texture = FrameUncommon
			"Rare":
				texture = FrameRare
			"Epic":
				texture = FrameEpic
			"Legendary":
				texture = FrameLegendary
		$CanvasLayer/Tooltip.initialize(Item.item_name, Item.item_type, Item.get_node("ItemStats").affixes)
	else:
		$Item.texture_normal = null
		$Quantity.text = ""
		texture = FrameBase


func assign_item(item):
	Item = item
	has_item = true
	update_slot()


func update_tooltip(item):
	$CanvasLayer/Tooltip.update_name_and_type(item.item_name, item.item_type)


func remove_item():
	has_item = false
	update_slot()


func _on_Item_pressed():
	if has_item:
		PlayerStats.equip_item(Item)
		PlayerStats.inventory_data[PlayerStats.current_bag].erase(int(name))
		$CanvasLayer/Tooltip.hide()
		remove_item()
		update_slot()


func _on_Slot_mouse_entered():
	if has_item:
		$CanvasLayer/Tooltip.show()


func _on_Slot_mouse_exited():
	if has_item:
		$CanvasLayer/Tooltip.hide()
