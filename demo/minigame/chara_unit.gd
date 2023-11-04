extends FloatableBody3D
class_name CharaUnit

const MOVE_SPEED = 5.0
const ROTATE_SPEED = 50.0

var target_position: Vector3
var moving := false

func _process(_delta):
	if global_position.y < -1.0:
		queue_free()


func _physics_process(delta):
	super._physics_process(delta)
	
	if moving:
		var diff = target_position - global_position
		diff.y = 0.0
		if diff.length() < 0.5:
			moving = false
		else:
			var move_direction = diff.normalized()
			linear_velocity += move_direction * MOVE_SPEED * delta
			var quat = Quaternion(basis.z, move_direction)
			var euler = quat.get_euler()
			angular_velocity = euler * ROTATE_SPEED * delta


func move_to(target_pos: Vector3):
	moving = true
	target_position = target_pos

func damage(value: int):
	mass += 1
