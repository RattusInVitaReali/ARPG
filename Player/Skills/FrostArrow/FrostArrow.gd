extends Node2D

const ElementalBlast = preload("res://Player/Skills/ElementalBlast/ElementalBlast.tscn")
var projectile_speed = 1200
var direction = Vector2(1, 0.5)

func _physics_process(delta):
	rotation = direction.angle()
	position = position + direction * projectile_speed * delta


func _on_Hitbox_area_entered(area):
	var elemental_blast = ElementalBlast.instance()
	elemental_blast.position = position
	get_parent().add_child(elemental_blast)
	queue_free()
