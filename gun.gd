extends Node2D
class_name Gun

@export var gun: GunResource

func _ready():
	gun.assemble_components(self)
	
	Global.hud.resized.connect(when_game_resize)
	when_game_resize()
	

func when_game_resize():
	position = Global.hud.size / 2
	#hammer_button.position = hammer.global_position
	#trigger_button.position = trigger.global_position
	#barrel_button.position = barrel.global_position
	

func printzin():
	print('oloko')
