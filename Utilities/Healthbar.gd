extends Control

func _ready():
	get_parent().get_node("Stats").connect("health_updated", self, "_on_health_updated")
	$HealthBar.value = $HealthBar.max_value

func _on_health_updated(newHealth):
	$HealthBar.value = get_parent().get_node("Stats").health_percent * $HealthBar.max_value

func _on_max_health_updated(newMaxHealth):
	$HealthBar.max_value = newMaxHealth

