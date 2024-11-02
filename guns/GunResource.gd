class_name GunResource
extends Resource

@export_range(1,12) var _bullets_capacity: = 1

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

func assemble_components(gun_node: Node2D, control_area: Control = null):
	var body = Sprite2D.new()
	body.texture = _body_texture
	body.name = 'Body'
	body.z_index = 1
	
	var barrel = Sprite2D.new()
	barrel.texture = _barrel_texture
	barrel.position = _barrel_position
	barrel.name = 'Barrel'
	
	var hammer = Sprite2D.new()
	hammer.position = _hammer_position
	hammer.texture = _hammer_texture
	hammer.offset = _hammer_offset
	
	hammer.name = 'Hammer'
	
	var trigger = Sprite2D.new()
	trigger.position = _trigger_position
	trigger.texture = _trigger_texture
	trigger.offset = _trigger_offset
	trigger.name = 'Trigger'
	
	
	gun_node.add_child(body)
	gun_node.add_child(barrel)
	gun_node.add_child(hammer)
	gun_node.add_child(trigger)
	
	if not control_area:
		gun_node.get_parent()
