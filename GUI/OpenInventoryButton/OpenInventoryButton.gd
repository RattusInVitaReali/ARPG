extends Control

const Inventory = preload("res://GUI/Inventory.tscn")


func _on_TextureButton_pressed():
	var inventory = Inventory.instance()
	add_child(inventory)
