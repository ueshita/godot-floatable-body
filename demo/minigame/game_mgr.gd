extends Node3D

@export var damage_obj_scene: PackedScene

var start_time := 3.0
var spawn_interval := 2.0

var time_count := 0.0
var last_spawn_time := 0.0

func _process(delta: float):
	time_count += delta
	if time_count >= start_time:
		if time_count - last_spawn_time >= spawn_interval:
			last_spawn_time = time_count
			var obj = damage_obj_scene.instantiate()
			if obj is Node3D:
				add_child(obj)
				obj.global_position = Vector3(randf_range(-5, 5), 10, randf_range(-5, 5))
				obj.global_rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))

			spawn_interval -= 0.05
			spawn_interval = max(spawn_interval, 0.2)


func move_to(target_pos: Vector3):
	%CharaMgr.move_to(target_pos)
