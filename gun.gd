extends Node2D
class_name Gun

@export var gun: GunResource

@onready var gun_audio_player: = $AudioPlayer

var trigger_activation: = 0.0:
	set = set_trigger_activation

var trigger_ready: = true

var hammer_activation: = 0.0
var hammer_ready: = false

var bullets_in_cylinder: Array[bool] = []
func _ready():
	gun.assemble_components(self, get_tree().root.get_node('/root/App/Triggers'))
	gun.trigger_button.limit = gun.trigger_button.size
	gun.trigger_button.button_down.connect(set_trigger_ready)
	for b in range(gun._bullets_capacity):
		bullets_in_cylinder.append(true)
	
	
	Global.hud.resized.connect(when_game_resize)
	when_game_resize()

func _physics_process(delta: float) -> void:
	if gun.trigger_button.swipe_offset.x > 0:
		set_trigger_activation(gun.trigger_button.swipe_offset.x/gun.trigger_button.size.x)

func set_trigger_activation(value: float):
	if not trigger_ready:
		return
		
	trigger_activation = value
	
	if trigger_activation >= 1.0:
		trigger_fire()
		trigger_activation = 0.0
		trigger_ready = false
	
	set_hammer_activation(trigger_activation)
	gun.trigger.rotation = lerp(gun.trigger_clamp[0], gun.trigger_clamp[1], trigger_activation) * PI / 180

func set_hammer_activation(value: float):
	hammer_activation = value
	
	if hammer_activation > 1.0:
		hammer_activation = 1.0
		hammer_ready = true
	
	gun.hammer.rotation = lerp(gun.hammer_clamp[0], gun.hammer_clamp[1], value) * PI / 180

func set_trigger_ready():
	trigger_ready = true

func trigger_fire():
	if get_chambered_bullet():
		gun_audio_player.stream = gun._fire_sound
	gun.trigger_button.release_swipe()
	gun_audio_player.play()

func get_chambered_bullet():
	return bullets_in_cylinder[0]

func when_game_resize():
	position = Global.hud.size / 2
	gun.update_buttons_position()
