extends VBoxContainer

const Border1 = preload("res://UI Images/Borders/Border1.png")
const Border2 = preload("res://UI Images/Borders/Border2.png")
const Border3 = preload("res://UI Images/Borders/Border3.png")
const Border4 = preload("res://UI Images/Borders/Border4.png")
const Border5 = preload("res://UI Images/Borders/Border5.png")
const Border6 = preload("res://UI Images/Borders/Border6.png")
const Border7 = preload("res://UI Images/Borders/Border7.png")
const Border8 = preload("res://UI Images/Borders/Border8.png")
const Border9 = preload("res://UI Images/Borders/Border9.png")

signal stat_allocated

export var StatName = ""
export var TooltipStatName = ""


func _ready():
	$Points.text = str(PlayerStats.allocated_stats[StatName])
	update_boreder()
	update_tooltip()


func _process(delta):
	var position = get_viewport().get_mouse_position()
	$CanvasLayer/Tooltip.set_global_position(position)


func _on_TextureButton_pressed():
	var error_message = "fu no points"
	if PlayerStats.stat_points_available > 0:
		if PlayerStats.stat_points_used - PlayerStats.allocated_stats[StatName] >= PlayerStats.allocated_stats[StatName]:
			PlayerStats.stat_points_available -= 1
			PlayerStats.stat_points_used += 1
			emit_signal("stat_allocated", StatName)
			update_boreder()
			update_tooltip()
			$Points.text = str(PlayerStats.allocated_stats[StatName])
			return
		else:
			error_message = "fu too much focus"
	print(error_message)

func update_boreder():
	$TextureRect.texture = get("Border" + str(PlayerStats.allocated_stats[StatName]))

func update_tooltip():
	$CanvasLayer/Tooltip.update_tooltip(TooltipStatName)

func _on_TextureButton_mouse_entered():
	$CanvasLayer/Tooltip.show()


func _on_TextureButton_mouse_exited():
	$CanvasLayer/Tooltip.hide()



















