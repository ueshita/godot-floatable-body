extends FloatableBody3D

var water_entered := false

func _ready():
	super._ready()
	$Mesh.scale = Vector3.ZERO


func _process(delta):
	if water_entered:
		mass += 1.0 * delta
	else:
		$Mesh.scale += Vector3.ONE * (1/sqrt(2.0) * delta)
	if global_position.y < -5:
		queue_free()


func fluid_area_enter(area: FluidArea3D):
	super.fluid_area_enter(area)

	if not water_entered:
		var pos = global_position
		var splash = preload("res://demo/minigame/splash2.tscn").instantiate()
		get_viewport().add_child(splash)
		splash.global_position = Vector3(pos.x, 0, pos.z)
	water_entered = true
