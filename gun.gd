extends Node2D
class_name Gun

@export var _bullet_capacity: = 6

@onready var hammer: = $Hammer
@onready var trigger: = $Trigger
@onready var body: = $Body
@onready var barrel: = $Barrel

@onready var hammer_button: = Global.hud.get_node('HammerButton')
@onready var trigger_button: = Global.hud.get_node('TriggerButton')
@onready var barrel_button: = Global.hud.get_node('BarrelButton')

var bullets_in_the_barrel: = []

func _init():
	for bullets in range(_bullet_capacity):
		bullets_in_the_barrel.append(1)

func _ready():
	Global.hud.resized.connect(when_game_resize)
	when_game_resize()

func when_game_resize():
	position = Global.hud.size / 2
	hammer_button.position = hammer.position
	trigger_button.position = trigger.position
	barrel_button.position = barrel.position
	

func printzin():
	print('oloko')
