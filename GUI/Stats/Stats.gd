extends HBoxContainer


func update_stats(affixes):
	for i in range(affixes.size()):
		for stat in get_tree().get_nodes_in_group("Stats"):
			if stat.name == "Stat" + str(i + 1):
				stat.text = affixes[i].name
				break
		for amount in get_tree().get_nodes_in_group("Amounts"):
			if amount.name == "Amount" + str(i + 1):
				amount.text = str(affixes[i].value)
				break
