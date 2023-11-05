extends Node3D
class_name CharaMgr

signal coin_earned()

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var coin_scene: PackedScene

var players: Array[CharaUnit]
var ingame: bool = false


func set_ingame(value: bool):
	ingame = value


func reset_all_units():
	for node in get_children():
		if node is RigidBody3D:
			node.queue_free()
	players.clear()
	
	for i in range(10):
		spawn_player()


func spawn_player(range: float = 1.0):
	var chara = player_scene.instantiate()
	if chara is Node3D:
		add_child(chara)
		players.push_back(chara)
		var angle = randf_range(0.0, 2.0 * PI)
		var radius = randf_range(0.0, range)
		var height = randf_range(-2, 2)
		var offset = Vector3(cos(angle) * radius, height, sin(angle) * radius)
		chara.global_position = Vector3(0, 4, 0) + offset
		chara.global_rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))
		chara.tree_exiting.connect(_on_player_destroyed.bind(chara))
	

func get_player_count():
	return len(players)


func player_move_to(target_pos: Vector3):
	for chara in players:
		var angle = randf_range(0.0, 2.0 * PI)
		var radius = randf_range(0.0, 0.6)
		var offset = Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
		chara.move_to(target_pos + offset)


func _on_player_destroyed(chara: CharaUnit):
	var index = players.find(chara)
	if index >= 0:
		players.remove_at(index)


func spawn_enemy():
	var obj = enemy_scene.instantiate()
	if obj is RigidBody3D:
		add_child(obj)
		obj.body_entered.connect(_on_enemy_body_entered.bind(obj))
		obj.global_position = Vector3(randf_range(-6, 6), 10, randf_range(-6, 6))
		obj.global_rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))


func _on_enemy_body_entered(target: Node, source: Node):
	if not ingame:
		return
	if source is Node3D and target is Node3D:
		if target is CharaUnit:
			if target.global_position.y < source.global_position.y:
				target.damage(1)
				$DuckAudio.play()


func spawn_coin():
	var obj = coin_scene.instantiate()
	if obj is RigidBody3D:
		add_child(obj)
		obj.body_entered.connect(_on_coin_body_entered.bind(obj))
		obj.global_position = Vector3(randf_range(-5, 5), 10, randf_range(-5, 5))
		obj.global_rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))


func _on_coin_body_entered(target: Node, source: Node):
	if not ingame:
		return
	if source is Node3D and target is Node3D:
		if target is CharaUnit:
			coin_earned.emit()
			source.queue_free()
			$CoinAudio.play()
