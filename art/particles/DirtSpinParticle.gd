extends ParticleAnimation

onready var dirt = $Dirt

func play() -> void:
	dirt.emitting = true

func stop() -> void:
	dirt.emitting = false
	emit_signal("finished")
