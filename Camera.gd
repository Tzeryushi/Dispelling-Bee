extends Camera2D

onready var timer = $Timer
onready var tween = $Tween

var shake_amount = 0
var default = offset

func _ready() -> void:
	Globals.camera = self
	set_process(false)

func _process(delta) -> void:
	offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default
	#print(offset)
	
func shake(shake_number, shake_time = 0.5) -> void:
	shake_amount += shake_number
	timer.wait_time = shake_time
	
	tween.stop_all()
	set_process(true)
	timer.start()
#make a shake function?

func _on_Timer_timeout():
	shake_amount = 0
	set_process(false)
	print("out")
	tween.interpolate_property(self, "offset", offset, default, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	timer.stop()
