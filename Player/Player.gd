extends KinematicBody2D

const Whirlwind = preload("res://Player/Skills/Whirlwind/Whirlwind.tscn")
const ElementalBlast = preload("res://Player/Skills/ElementalBlast/ElementalBlast.tscn")
const FrostArrow = preload("res://Player/Skills/FrostArrow/FrostArrow.tscn")

const base_acceleration = 500
const base_max_speed = 120
const base_friction = 500

var acceleration = 500
var max_speed = 120
var friction = 500

enum {
	MOVE,
	SKILL
}

var state = MOVE
var velocity = Vector2.ZERO

var skills = {}

var current_skill
var is_using_skill = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	current_skill = Whirlwind
	animationTree.active = true

func _physics_process(delta):
	PlayerStats.calculate_stats()
	match state:
		MOVE:
			move_state(delta)
		
		SKILL:
			skill_state(delta, current_skill)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = move_and_slide(velocity)

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)
	if event.is_action_pressed("ui_attack"):
		skill_whirlwind()
	if event.is_action_pressed("ui_attack2"):
		skill_elemental_blast()
	if event.is_action_pressed("ui_attack3"):
		skill_frost_arrow()


func skill_state(_delta, Skill):
	if !is_using_skill:
		animationTree.active = false
		is_using_skill = true


#SKILLS
func skill_whirlwind():
	if !is_using_skill:
		state = SKILL
		$AnimationPlayer.play("Whirlwind", -1, PlayerStats.active_stats.attack_speed)
		var whirlwind = Whirlwind.instance()
		add_child(whirlwind)

func skill_elemental_blast():
	if !is_using_skill:
		state = SKILL
		$AnimationPlayer.play("ElementalBlast", -1, PlayerStats.active_stats.attack_speed)
		var elementalBlast = ElementalBlast.instance()
		get_parent().add_child(elementalBlast)
		elementalBlast.position = get_global_mouse_position()

func skill_frost_arrow():
	if !is_using_skill:
		var frostArrow = FrostArrow.instance()
		var dir = (get_global_mouse_position() - position).normalized()
		frostArrow.direction = dir
		frostArrow.position = position
		get_parent().add_child(frostArrow)

func skill_finished():
	SkillManager.skill_finished()
	is_using_skill = false
	animationTree.active = true
	state = MOVE
