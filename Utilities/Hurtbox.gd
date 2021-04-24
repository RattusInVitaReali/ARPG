extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(_area):
	if show_hit:
		var hitEffect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(hitEffect)
		hitEffect.global_position = global_position
