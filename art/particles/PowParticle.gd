extends ParticleAnimation

onready var stars = $Stars
onready var needles = $Needles
onready var flash = $Flash
onready var boom = $Boom

export var boom_time : float = 0.3

var start = false
var booming = true
var boom_delta = 0

func _process(delta) -> void:
	if booming == true:
		boom_delta += delta
		if boom_delta >= boom_time:
			boom.emitting = false
			booming = false
	if start and !stars.emitting and !needles.emitting and !flash.emitting and !boom.emitting:
		emit_signal("finished")

func play() -> void:
	start = true
	stars.emitting = true
	needles.emitting = true
	flash.emitting = true
	boom.emitting = true
	booming = true

func stop() -> void:
	start = false
	booming = false
	stars.emitting = false
	needles.emitting = false
	flash.emitting = false
	boom.emitting = false
	boom_delta = 0
	emit_signal("finished")
