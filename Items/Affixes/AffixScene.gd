extends Node2D


var value
var show_as_percent

func initialize(_name : String, _value : float, _show_as_percent) -> void:
	name = _name
	value = _value
	show_as_percent = _show_as_percent
