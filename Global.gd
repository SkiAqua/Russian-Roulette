extends Node

var debug: = true

@onready var hud: = get_tree().root.get_node('/root/App/HUD')

@onready var triggers: = get_tree().root.get_node('/root/App/Triggers'):
	get = get_triggers

func _init():
	pass

func get_triggers():
	return get_tree().root.get_node('/root/App/Triggers')
