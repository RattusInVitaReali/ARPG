extends Node2D

signal portal_entered

func _ready():
	connect("portal_entered", get_parent(), "onPortalEntered")



func _on_Area2D_body_entered(body):
	emit_signal("portal_entered")
