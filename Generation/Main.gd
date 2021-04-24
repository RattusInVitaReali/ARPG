extends Node2D

const Scene = preload("res://Generation/LevelGenerator.tscn")

func _ready():
	var scene = Scene.instance()
	add_child(scene)


func generate_new_level(level_floor):
	GameData.Floor = level_floor
	var scene = Scene.instance()
	add_child(scene)
