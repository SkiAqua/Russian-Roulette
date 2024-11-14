extends Node2D
class_name Gun

@export var gun_data: GunResource 

@onready var audio_player = $FirePlayer
@onready var tick_player = $TickPlayer
@onready var animation_player = $Animation

var trigger_pull_ratio = 0.0:
	set = set_trigger_pull_ratio
var trigger_fire_point = 0.9
var is_trigger_ready = false

var hammer_pull_ratio = 0.0
var is_hammer_ready = true
var is_hammer_locked = false

var cylinder: Array[bool] = []
var cylinder_roll_direction: = 1
@onready var cylinder_timer = Timer.new()
@onready var selected_chamber = randi_range(1, gun_data.bullets_capacity)

func _ready():
	gun_data.assemble_components(self, get_tree().root.get_node('/root/App/Triggers'))
	gun_data.trigger_button.limit = gun_data.trigger_button.size
	is_trigger_ready = gun_data.is_double_action

	initialize_cylinder()
	Global.hud.resized.connect(adjust_position_on_resize)
	adjust_position_on_resize()
	
	gun_data.barrel_button.swipe.connect(roll_cylinder)
	cylinder_timer.one_shot = false
	cylinder_timer.timeout.connect(tick_cylinder)
	add_child(cylinder_timer)
	cylinder.pop_at(0)
	cylinder.insert(randi_range(1, gun_data.bullets_capacity - 1), true)

func _physics_process(delta):
	if gun_data.trigger_button.drag_offset.x > 0:
		set_trigger_pull_ratio(gun_data.trigger_button.drag_offset.x / gun_data.trigger_button.size.x)
	elif trigger_pull_ratio > 0:
		set_trigger_pull_ratio(trigger_pull_ratio - 0.1)

	if gun_data.hammer_button.drag_offset.x > 0:
		set_hammer_pull_ratio(gun_data.hammer_button.drag_offset.x / gun_data.hammer_button.size.x)

func set_trigger_pull_ratio(value: float):
	trigger_pull_ratio = clamp(value, 0, 1)
	gun_data.trigger.rotation = lerp(gun_data.trigger_start_angle, gun_data.trigger_final_angle, trigger_pull_ratio) * PI / 180
	
	if gun_data.is_double_action:
		set_hammer_pull_ratio(trigger_pull_ratio)
	
	if trigger_pull_ratio >= trigger_fire_point and is_trigger_ready:
		fire()
		is_hammer_locked = false
		set_hammer_pull_ratio(0.0)
		is_hammer_locked = true
		is_trigger_ready = false

	if trigger_pull_ratio <= 0.1 and !is_trigger_ready:
		is_hammer_locked = false
		if gun_data.is_double_action:
			is_trigger_ready = true

func set_hammer_pull_ratio(value: float):
	if is_hammer_locked:
		return
	
	hammer_pull_ratio = clamp(value, 0.0, 1.0)
	gun_data.hammer.rotation = lerp(gun_data.hammer_start_angle, gun_data.hammer_final_angle, hammer_pull_ratio) * PI / 180
	
	if hammer_pull_ratio == 1.0:
		is_trigger_ready = true
		is_hammer_locked = true

func roll_cylinder(force: Vector2):
	cylinder_timer.wait_time = 5 / abs(force.y)
	if force.y > 0:
		cylinder_roll_direction = -1
	elif force.y < 0:
		cylinder_roll_direction = 1
	tick_cylinder()

func tick_cylinder():
	if cylinder_timer.wait_time > 0.2:
		cylinder_timer.stop()
		return
	move_selected_chamber()
	cylinder_timer.start(cylinder_timer.wait_time * 1.2)

func move_selected_chamber():
	# Avança ou retrocede a câmara selecionada, dependendo do valor positivo ou negativo de 'direction'
	selected_chamber = (selected_chamber + cylinder_roll_direction) % gun_data.bullets_capacity
	if selected_chamber < 0:
		selected_chamber += gun_data.bullets_capacity
	tick_player.stream = gun_data._barrel_roll_sound
	
	tick_player.play()
	print('-----------------')
	for n in range(gun_data.bullets_capacity):
		print(cylinder[n])
		if selected_chamber== n:
			print('^^^')

func fire():
	cylinder_roll_direction = 1
	if is_bullet_chambered():
		audio_player.stream = gun_data._fire_sound
		animation_player.stop()
		animation_player.play("fire")
	else:
		audio_player.stream = gun_data._free_chamber_sound
	move_selected_chamber()
	cylinder_timer.stop()
	audio_player.play()
	

func is_bullet_chambered() -> bool:
	return cylinder[selected_chamber]

func adjust_position_on_resize():
	position = Global.hud.size / 2
	gun_data.update_buttons_position()

func initialize_cylinder():
	cylinder.clear()
	for __ in range(gun_data.bullets_capacity):
		cylinder.append(false)
