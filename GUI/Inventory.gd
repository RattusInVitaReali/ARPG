extends Control

const InventoryTab = preload("res://GUI/MainElementsInventory.tscn")
const Stat = preload("res://GUI/Stat.tscn")

onready var Tab = $Background/PaperBackground/VBoxContainer/TabContainer
onready var Stats = $Background/PaperBackground/VBoxContainer/TabContainer/MainElementsStats/Stats/Stats/Stats

var inv = true


func _ready():
	connect_stat_slots()
	PlayerStats.connect("update_slot", self, "update_slot")
	$Background/PaperBackground/VBoxContainer/Header/Gold.text = str(PlayerStats.gold)
	load_bag(PlayerStats.current_bag)
	generate_stats()


func update_slot(slot_name):
	for slot in get_tree().get_nodes_in_group("Equipment"):
		if slot.name == str(slot_name):
			slot.assign_item(PlayerStats.equipment[slot_name])
			return
	for slot in get_tree().get_nodes_in_group("Slots"):
		if slot.name == str(slot_name):
			slot.assign_item(PlayerStats.inventory_data[PlayerStats.current_bag][slot_name])
			return


func update_all_slots(bag_number):
	for slot in get_tree().get_nodes_in_group("Slots"):
		slot.remove_item()
	for item in PlayerStats.inventory_data[bag_number]:
		for slot in get_tree().get_nodes_in_group("Slots"):
			if slot.name == str(item):
				slot.assign_item(PlayerStats.inventory_data[bag_number][item])
				break
	for item in PlayerStats.equipment:
		if PlayerStats.equipment[item] != null:
			for slot in get_tree().get_nodes_in_group("Equipment"):
				if slot.name == item:
					slot.assign_item(PlayerStats.equipment[item])
					break


func _on_ExitButton_pressed():
	queue_free()


func _on_NextBag_pressed():
	if PlayerStats.current_bag != PlayerStats.bags_equipped:
		PlayerStats.current_bag += 1
		load_bag(PlayerStats.current_bag)


func _on_PreviousBag_pressed():
	if PlayerStats.current_bag != 1:
		PlayerStats.current_bag -= 1
		load_bag(PlayerStats.current_bag)

func load_bag(bag):
	$Background/PaperBackground/VBoxContainer/TabContainer/MainElementsInventory/Center/BagSelection/BagName.text = "Bag " + str(PlayerStats.current_bag)
	update_all_slots(bag)

func _on_Inventory_pressed():
	Tab.set_current_tab(0)


func _on_Stats_pressed():
	Tab.set_current_tab(1)
	update_stats()

func generate_stats():
	for stat in PlayerStats.active_stats:
		var new_stat = Stat.instance()
		new_stat.set_stat(stat)
		Stats.add_child(new_stat)
		new_stat.add_to_group("Stats")

func update_stats():
	PlayerStats.calculate_stats()
	for stat in get_tree().get_nodes_in_group("Stats"):
		stat.update_value()
	$Background/PaperBackground/VBoxContainer/TabContainer/MainElementsStats/Stats/TopPart/AvailablePoints/PointCount.text = "Available Points: " + str(PlayerStats.stat_points_available)

func connect_stat_slots():
	for slot in get_tree().get_nodes_in_group("StatSlots"):
		slot.connect("stat_allocated", self, "allocate_stat")

func allocate_stat(stat_name):
	PlayerStats.allocated_stats[stat_name] += 1 
	update_stats()















