extends Area2D

export var shape = true
export var polygon = false

var total_damage = {"physical_damage": 0, "fire_damage": 0, "ice_damage": 0, "lightning_damage": 0}

func _ready():
	if shape:
		$CollisionShape2D.scale = Vector2(PlayerStats.active_stats.aoe, PlayerStats.active_stats.aoe)
		$CollisionPolygon2D.queue_free()
	if polygon:
		$CollisionPolygon2D.scale = Vector2(PlayerStats.active_stats.aoe, PlayerStats.active_stats.aoe)
		$CollisionShape2D.queue_free()
