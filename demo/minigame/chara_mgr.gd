extends Node3D
class_name CharaMgr

@export var chara_scene: PackedScene
var charas: Array[CharaUnit]

func _ready():
	charas = []

	for i in range(10):
		var chara = chara_scene.instantiate()
		if chara is Node3D:
			add_child(chara)
			charas.push_back(chara)
			var angle = randf_range(0.0, 2.0 * PI)
			var radius = randf_range(0.0, 0.5)
			var offset = Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
			chara.global_position = Vector3(0, 3, 0) + offset
			chara.global_rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))
			chara.tree_exiting.connect(_on_chara_destroyed.bind(chara))


func move_to(target_pos: Vector3):
	for chara in charas:
		var angle = randf_range(0.0, 2.0 * PI)
		var radius = randf_range(0.0, 0.5)
		var offset = Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
		chara.move_to(target_pos + offset)


func _on_chara_destroyed(chara: CharaUnit):
	var index = charas.find(chara)
	if index >= 0:
		charas.remove_at(index)
