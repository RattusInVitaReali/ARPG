extends Node

signal skill_finished

func skill_finished():
	emit_signal("skill_finished")
