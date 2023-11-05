extends FloatableBody3D
class_name CharaUnit

const MOVE_SPEED = 5.0
const ROTATE_SPEED = 100.0

var target_position: Vector3
var moving := false
var water_entered := false

func _process(_delta):
	if global_position.y < -3.0:
		queue_free()


func _physics_process(delta):
	super._physics_process(delta)
	
	if moving:
		var diff = target_position - global_position
		diff.y = 0.0
		if diff.length() < 0.5:
			moving = false
		else:
			var target_direction = diff.normalized()
			if not target_direction.is_equal_approx(basis.z):
				var quat = Quaternion(basis.z, target_direction)
				var euler = quat.get_euler()
				angular_velocity = euler * ROTATE_SPEED * delta
			
			linear_velocity += basis.z * MOVE_SPEED * delta


func move_to(target_pos: Vector3):
	moving = true
	target_position = target_pos


func damage(value: int):
	mass += 1


func fluid_area_enter(area: FluidArea3D):
	super.fluid_area_enter(area)

	if not water_entered:
		var pos = global_position
		var splash = preload("res://demo/minigame/splash1.tscn").instantiate()
		get_viewport().add_child(splash)
		splash.global_position = Vector3(pos.x, 0, pos.z)
	water_entered = true
