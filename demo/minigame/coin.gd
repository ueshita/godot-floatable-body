extends FloatableBody3D

@onready var mesh = $Mesh
var water_entered := false


func _process(delta: float):
	mesh.rotate_y(delta)


func fluid_area_enter(area: FluidArea3D):
	super.fluid_area_enter(area)

	if not water_entered:
		var pos = global_position
		var splash = preload("res://demo/minigame/splash1.tscn").instantiate()
		get_viewport().add_child(splash)
		splash.global_position = Vector3(pos.x, 0, pos.z)
	water_entered = true
