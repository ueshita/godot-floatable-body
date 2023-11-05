extends Node3D

var pos_area_min := Vector3(-5, 0, -5)
var pos_area_max := Vector3(5, 0, 5)
var cursor_visible := false

@onready var game := %GameMgr
@onready var camera := $Camera3D
@onready var cursor := $Cursor


func _ready():
	pass


func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 100
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space_state.intersect_ray(query)
	if not result.is_empty():
		cursor.visible = cursor_visible
		var pos = result["position"]
		cursor.global_position = Vector3(
			clamp(pos.x, pos_area_min.x, pos_area_max.x),
			clamp(pos.y, pos_area_min.y, pos_area_max.y),
			clamp(pos.z, pos_area_min.z, pos_area_max.z),
		)
	else:
		cursor.visible = false


func set_cursor_visible(value: bool):
	cursor_visible = value


func get_cursor_pos():
	return cursor.global_position
