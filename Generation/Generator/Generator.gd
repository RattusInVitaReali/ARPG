extends Node2D

var thingToSpawn
var amountToSpawn

func _ready():
	generate(amountToSpawn)

func generate(amount):
	yield(get_tree().create_timer(0), "timeout")
	randomize()
	for _i in range (amount):
		var x = int(rand_range(-20, 20))
		var y = int(rand_range(-20, 20))
		var thing = thingToSpawn.instance()
		get_parent().add_child(thing)
		thing.position = Vector2(x, y) + position
	queue_free()

func generateEnemies(amount):
	yield(get_tree().create_timer(0), "timeout")
	randomize()
	for _i in range (amount):
		var x = int(rand_range(-20, 20))
		var y = int(rand_range(-20, 20))
		var thing = thingToSpawn.instance()
		get_parent().add_child(thing)
		thing.position = Vector2(x, y) + position
		thing.get_node("Stats").health *= GameData.Floor
	queue_free()
