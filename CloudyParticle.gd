extends ParticleAnimation

onready var cloud1 = $Cloud
onready var cloud2 = $Cloud2
onready var cloud3 = $Cloud3
onready var cloud4 = $Cloud4

export var cloud_time = 40.0

var start = false
var start_delta = 0

#process will call particle to act over a certain time
#function can be called to shut down effect prematurely

func _process(delta) -> void:
	if start == true:
		start_delta += delta
		if start_delta >= cloud_time:
			_end()

func _end() -> void:
	cloud1.emitting = false
	cloud2.emitting = false
	cloud3.emitting = false
	cloud4.emitting = false
	emit_signal("finished")

func play() -> void:
	start = true
	cloud1.emitting = true
	cloud2.emitting = true
	cloud3.emitting = true
	cloud4.emitting = true
	
func stop() -> void:
	start = false
	_end()
