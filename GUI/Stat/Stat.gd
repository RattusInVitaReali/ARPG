extends HBoxContainer

var stat_name
var percentage = false

func set_stat(name):
	stat_name = name
	var actual_name
	match name:
		"aoe":
			actual_name = "Area of Effect"
		_:
			actual_name = name.capitalize()
	$StatName.text = actual_name
	match name:
		"aoe", "critical_strike_chance", "critical_strike_multiplier", "attack_speed":
			percentage = true
	update_value()

func update_value():
	var text = str(PlayerStats.active_stats[stat_name])
	if percentage:
		text = str(100 * PlayerStats.active_stats[stat_name]) + "%"
	$StatValue.text = text


