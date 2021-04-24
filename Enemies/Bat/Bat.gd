extends KinematicBody2D

export var lootID = "Forest1"
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Item = preload("res://Utilities/Items/Item.tscn")
const Lootable = preload("res://Utilities/Items/Lootable.tscn")


enum {
	IDLE,
	WANDER,
	CHASE
}

export var experience = 10

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

signal health_updated

func _ready():
	$Stats.connect("die", self, "die")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, $Stats.friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, $Stats.friction)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = $PlayerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * $Stats.max_speed, $Stats.acceleration * delta)
				$Sprite.flip_h = direction.x < 0
			else:
				state = IDLE
	
	velocity = move_and_slide(velocity)


func seek_player():
	if $PlayerDetectionZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	$Stats.take_damage(area.total_damage)

func _on_Stats_no_health():
	die()


func die():
	PlayerStats.add_experience(experience)
	randomize()
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var loot = LootGenerator.generate_loot(lootID)
	LootGenerator.generate_lootables(loot, position)
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
