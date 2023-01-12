extends Node2D

onready var body = $Pos/Image
onready var hand_1 = $Pos/Image/HandPivot1
onready var hand_2 = $Pos/Image/HandPivot2
onready var player := $Pos/AnimationPlayer

export var cloud_particle : PackedScene

var particle
var is_cloudy := false

func attack() -> void:
	hand_1.attack()
	hand_2.attack()

func attack2() -> void:
	hand_1.attack()
	hand_2.attack()
	#make the poof thing go brr
	if is_cloudy:
		if is_instance_valid(particle):
			particle.queue_free()
	else:
		is_cloudy = true
	particle = cloud_particle.instance()
	add_child(particle)
	particle.set_global_position(Vector2(0.0,0.0))
	particle.play()
	yield(particle, "finished")
	is_cloudy = false
	
func hurt() -> void:
	player.play("Hurt")
	yield(player, "animation_finished")
	player.play("Idle")

func dispelled() -> void:
	player.play("Dispelled")
	yield(player, "animation_finished")
	player.play("Idle")

func lose() -> void:
	hand_1.slow_rotation()
	hand_2.slow_rotation()
	player.play("LoseStart")
	var tween = create_tween()
	tween.tween_method(self, "change_body_discorp", 0.0, 1.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	yield(player,"animation_finished")
	player.stop()

func change_body_discorp(amount:float) -> void:
	body.material.set_shader_param("progress", amount)

func win() -> void:
	pass
