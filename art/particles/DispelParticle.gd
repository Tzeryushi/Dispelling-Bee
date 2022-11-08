extends ParticleAnimation

var started = false

func _process(delta):
	if !$Flash.emitting and !$Stars.emitting and started:
		emit_signal("finished")

func play() -> void:
	$Flash.emitting = true
	$Stars.emitting = true

func stop() -> void:
	$Flash.emitting = false
	$Stars.emitting = false
