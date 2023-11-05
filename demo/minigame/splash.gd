extends GPUParticles3D

@onready var audio := $Audio

func _ready():
	emitting = true
	
	if audio:
		audio.pitch_scale = randf_range(0.8, 1.5)
		audio.play()
		audio.finished.connect(func(): queue_free())
	else:
		finished.connect(func(): queue_free())
