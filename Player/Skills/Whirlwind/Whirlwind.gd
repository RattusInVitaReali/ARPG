extends Node2D

func _ready():
	SkillManager.connect("skill_finished", self, "skill_finished")
	var physical_damage = PlayerStats.active_stats.physical_damage
	var fire_damage = PlayerStats.active_stats.fire_damage
	var ice_damage = PlayerStats.active_stats.ice_damage
	var lightning_damage = PlayerStats.active_stats.lightning_damage
	var total_damage = {"physical_damage": physical_damage, "fire_damage": fire_damage, "ice_damage": ice_damage, "lightning_damage": lightning_damage}
	$Hitbox.total_damage = total_damage

func skill_finished():
	queue_free()
