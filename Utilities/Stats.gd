extends Node

onready var active_stats = {"health": float(0), "accuracy": 0, "physical_damage": 0, "fire_damage": 0, "ice_damage": 0, "lightning_damage": 0,
					 "critical_strike_chance": 0, "critical_strike_multiplier": 0, "attack_speed": 0, "aoe": 0,
					 "armor": 0, "movement_speed": 0, "resists": {"fire_resistance": 0, "ice_resistance": 0, "lightning_resistance": 0}}

export(float) var max_health = 0
export var movement_speed = 0
export var max_speed = 0
export var acceleration = 0
export var friction = 0

export var base_evasion = 0
export var base_armor = 0
export(float) var base_fire_resistance = 0
export(float) var base_ice_resistance = 0
export(float) var base_lightning_resistance = 0

var health_percent = float(1)

signal die
signal health_updated

func _ready():
	active_stats.health = max_health
	active_stats.armor = base_armor


func take_damage(damage):
	damage = DamageManager.calculate_total_damage(damage, active_stats.armor, active_stats.resists)
	print("Damage: ", damage)
	active_stats.health -= damage
	emit_signal("health_updated", active_stats.health)
	if active_stats.health <= 0:
		emit_signal("die")

func _on_Stats_health_updated(_hp):
	health_percent = float(active_stats.health / max_health)
	print(str(health_percent) + "% hp")
