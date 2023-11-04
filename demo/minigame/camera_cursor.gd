extends Node3D

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
		cursor.visible = true
		cursor.global_position = result["position"]
	else:
		cursor.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			game.move_to(cursor.global_position)

