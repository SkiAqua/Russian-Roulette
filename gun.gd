@tool
extends Node2D
class_name Gun

@export var _bullet_capacity: = 6

@onready var hammer: = $Hammer
@onready var trigger: = $Trigger
@onready var body: = $Body
@onready var barrel: = $Barrel

var hammer_button: GunComponentButton
var trigger_button: GunComponentButton
var barrel_button: GunComponentButton
var bullets_in_the_barrel: Array[bool] = []

func _init():
	for bullets in range(_bullet_capacity):
		bullets_in_the_barrel.append(false)

func _ready():
	hammer_button = GunComponentButton.new(hammer)
	get_parent().get_node('Triggers').add_child(hammer_button)
	
	Global.hud.resized.connect(when_game_resize)
	when_game_resize()

func when_game_resize():
	position = Global.hud.size / 2
	#hammer_button.position = hammer.global_position
	#trigger_button.position = trigger.global_position
	#barrel_button.position = barrel.global_position
	

func printzin():
	print('oloko')
