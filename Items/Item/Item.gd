extends Node2D

var item_ID
var item_name
var item_type
var item_subtype
var item_rarity
var item_level

var stackable 
var quantity = 1

var texture_path

export var possible_affixes = []

func generate_texture_path():
	texture_path = "res://ImageResources/" + item_type + "/" + item_ID + ".png" 

