class_name GunResource
extends Resource

@export_range(1,12) var _bullets_capacity: = 1
@export var _fire_sound: AudioStream
@export var _body_texture: Texture2D
@export var _barrel_position: Vector2
@export var _hammer_position: Vector2
@export var _trigger_position: Vector2

@export_category('Barrel')
@export var _barrel_texture: Texture2D
@export var _barrel_decals_texture: Texture2D

@export_category('Hammer')
@export var _hammer_texture: Texture2D
@export var _hammer_offset: Vector2

@export_category('Trigger')
@export var _trigger_texture: Texture2D
@export var _trigger_offset: Vector2

@export_category('Roration Angles')

@export var trigger_start_angle: = 0
@export var trigger_final_angle: = -30

@export var hammer_start_angle: = 0
@export var hammer_final_angle: = 30

var trigger_button: SwipeButton
var hammer_button: SwipeButton
var barrel_button: SwipeButton

var body
var barrel
var hammer
var trigger

#Variável para saber se a arma já foi inicializada
var assembled: = false

func assemble_components(gun_node: Node2D, control_area: Node = null):	
	if not assembled:
		body = Sprite2D.new()
		barrel = Sprite2D.new()
		hammer = Sprite2D.new()
		trigger = Sprite2D.new()
	
	body.texture = _body_texture
	body.name = 'Body'
	body.z_index = 1
	
	
	barrel.texture = _barrel_texture
	barrel.position = _barrel_position
	barrel.name = 'Barrel'
	
	
	hammer.position = _hammer_position
	hammer.texture = _hammer_texture
	hammer.offset = _hammer_offset
	
	hammer.name = 'Hammer'
	
	
	trigger.position = _trigger_position
	trigger.texture = _trigger_texture
	trigger.offset = _trigger_offset
	trigger.name = 'Trigger'
	
	
	gun_node.add_child(body)
	gun_node.add_child(barrel)
	gun_node.add_child(hammer)
	gun_node.add_child(trigger)
	
	if control_area == null:
		control_area = gun_node.get_parent()
	
	trigger_button = SwipeButton.new()
	hammer_button = SwipeButton.new()
	barrel_button = SwipeButton.new()
	
	update_buttons_position()
	
	control_area.add_child(trigger_button)
	control_area.add_child(hammer_button)
	control_area.add_child(barrel_button)
	
	assembled = true
	
func update_buttons_position():
	trigger_button.size = _trigger_texture.get_size()+ Vector2(40,10)
	trigger_button.global_position = trigger.global_position + trigger.offset - trigger_button.size/2 + Vector2(-10,15)

	
	hammer_button.size = _hammer_texture.get_size()
	hammer_button.global_position = hammer.global_position + hammer.offset - hammer_button.size/2
	
	barrel_button.size = _barrel_texture.get_size()
	barrel_button.global_position = barrel.global_position + barrel.offset - barrel_button.size/2
