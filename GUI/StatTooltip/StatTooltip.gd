extends TextureRect

func update_tooltip(TooltipStatName):
	$VBoxContainer/StatName.text = TooltipStatName
	match TooltipStatName:
		"Brawn":
			$VBoxContainer/Description.text = "Deal " + str(100 * PlayerStats.base_physical_damage_stat) + "% more Physical Damage per point"
		"Quickness":
			$VBoxContainer/Description.text = "Increases Base Attack Speed by " + str(100 * PlayerStats.base_attack_speed_stat) + "% per point."
		"Reach":
			$VBoxContainer/Description.text = "Increases Base Area of Effect by " + str(100 * PlayerStats.base_aoe_stat) + "% per point."
		"Fury":
			$VBoxContainer/Description.text = "Adds " + str(100 * PlayerStats.base_critical_strike_chance_stat) + "% Base Critical Strike Chance per point."
		"Ferocity":
			$VBoxContainer/Description.text = "Increases total Critical Strike Multiplier by " + str(100 * PlayerStats.total_critical_strike_multiplier_stat) + "%."
		"Evocation: Fire":
			$VBoxContainer/Description.text = "Deal " + str(100 * PlayerStats.base_fire_damage_stat) + "% more Fire Damage per point"
		"Evocation: Ice":
			$VBoxContainer/Description.text = "Deal " + str(100 * PlayerStats.base_ice_damage_stat) + "% more Ice Damage per point"
		"Evocation: Lightning":
			$VBoxContainer/Description.text = "Deal " + str(100 * PlayerStats.base_lightning_damage_stat) + "% more Lightning Damage per point"
