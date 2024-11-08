extends Node2D
class_name Gun

@export var gun_data: GunResource 

@onready var audio_player := $AudioPlayer
@onready var animation_player := $Animation

var trigger_pull_ratio := 0.0:
	set = set_trigger_pull_ratio

var trigger_fire_point = 0.9
var trigger_ready: bool

var hammer_pull_ratio := 0.0
var hammer_ready := true
var hammer_locked = false

var cylinder: Array[bool] = []

@onready var cylinder_selected: = randi_range(1, gun_data.bullets_capacity)
func _ready():
	gun_data.assemble_components(self, get_tree().root.get_node('/root/App/Triggers'))
	gun_data.trigger_button.limit = gun_data.trigger_button.size
	#gun_data.trigger_button.button_down.connect(reset_trigger_ready)
	if gun_data.is_double_action:
		trigger_ready = true
	else:
		trigger_ready = false


	# Inicializa o cilindro sem balas, conforme a capacidade definida
	cylinder.clear()  # Garante que o cilindro comece vazio antes de adicionar balas
	for __ in range(gun_data.bullets_capacity):
		cylinder.append(false)  # Adiciona um espaço vazio para cada posição no cilindro

	# Conecta o evento de redimensionamento da HUD e ajusta a posição inicialmente
	Global.hud.resized.connect(adjust_position_on_resize)
	adjust_position_on_resize()
	
	#temp
	cylinder.pop_at(0)
	cylinder.insert(randi_range(1,gun_data.bullets_capacity-1), true)


func _physics_process(delta: float) -> void:
	# Atualiza o quanto o gatilho foi puxado
	if gun_data.trigger_button.swipe_offset.x > 0:
		set_trigger_pull_ratio(gun_data.trigger_button.swipe_offset.x / gun_data.trigger_button.size.x)
	elif trigger_pull_ratio > 0:
		set_trigger_pull_ratio(trigger_pull_ratio - 0.1)

	# Atualiza o quanto o martelo foi puxado
	if gun_data.hammer_button.swipe_offset.x > 0:
		set_hammer_pull_ratio(gun_data.hammer_button.swipe_offset.x / gun_data.hammer_button.size.x)

func set_trigger_pull_ratio(value: float):
	trigger_pull_ratio = clamp(value, 0, 1)
	gun_data.trigger.rotation = lerp(gun_data.trigger_start_angle, gun_data.trigger_final_angle, trigger_pull_ratio) * PI / 180
	
	# Em ação dupla, o gatilho também controla o martelo
	if gun_data.is_double_action:
		set_hammer_pull_ratio(trigger_pull_ratio)
	
	if trigger_pull_ratio >= trigger_fire_point and trigger_ready:
		fire()
		hammer_locked = false
		set_hammer_pull_ratio(0.0)
		hammer_locked = true
		trigger_ready = false

	# Reinicia o gatilho e o martelo ao soltar
	if trigger_pull_ratio <= 0.1 and !trigger_ready:
		hammer_locked = false
		if gun_data.is_double_action:
			trigger_ready = true

func set_hammer_pull_ratio(value: float):
	if hammer_locked:
		return
	
	hammer_pull_ratio = clamp(value, 0.0, 1.0)
	gun_data.hammer.rotation = lerp(gun_data.hammer_start_angle, gun_data.hammer_final_angle, hammer_pull_ratio) * PI / 180
	
	# Em ação simples, o martelo deve ser puxado manualmente para disparar
	if hammer_pull_ratio == 1.0:
		trigger_ready = true  # Gatilho pronto para disparar com menor movimento
		hammer_locked = true

func reset_trigger_ready():
	trigger_ready = true

func fire():
	if is_bullet_chambered():
		audio_player.stream = gun_data._fire_sound
		animation_player.stop()
		animation_player.play("fire")
		
	else:
		audio_player.stream = preload("res://assets/Revolver Empty.wav")
	
	print(cylinder_selected)
	cylinder_selected = (cylinder_selected + 1) % gun_data.bullets_capacity
	
	audio_player.play()

func is_bullet_chambered() -> bool:
	return cylinder[cylinder_selected]

func adjust_position_on_resize():
	position = Global.hud.size / 2
	gun_data.update_buttons_position()
