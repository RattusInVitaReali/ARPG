extends Node2D

func _ready():
	$AnimatedSprite.scale *= PlayerStats.active_stats.aoe
	$AnimatedSprite.play("Blast")
	var physical_damage = 0
	var fire_damage = PlayerStats.active_stats.fire_damage * 3
	var ice_damage = PlayerStats.active_stats.ice_damage * 3
	var lightning_damage = PlayerStats.active_stats.lightning_damage * 3
	var total_damage = {"physical_damage": physical_damage, "fire_damage": fire_damage, "ice_damage": ice_damage, "lightning_damage": lightning_damage}
	$Hitbox.total_damage = total_damage

func skill_finished():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	skill_finished()
