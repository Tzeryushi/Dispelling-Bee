extends TextureProgress

onready var timer = $HoneyTimer
var percentage

func _process(delta) -> void:
	if timer.get_time_left() > 0:
		percentage = (1-timer.get_time_left()/timer.get_wait_time())
		self.value = self.max_value * percentage

func set_timer(time:float) -> void:
	timer.set_wait_time(time)
	timer.start()

func start_timer() -> void:
	timer.start()
