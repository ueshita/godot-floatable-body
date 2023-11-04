extends FloatableBody3D

func _ready():
	super._ready()
	body_entered.connect(_on_body_entered)


func _process(delta):
	mass += 1.0 * delta
	if global_position.y < -5:
		queue_free()


func _on_body_entered(node: Node):
	if node.has_method("damage"):
		node.damage(1)
