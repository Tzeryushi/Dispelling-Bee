extends Node2D

onready var body = $Pos/Image
onready var hand_1 = $Pos/Image/HandPivot1
onready var hand_2 = $Pos/Image/HandPivot2
onready var player := $Pos/AnimationPlayer

func attack() -> void:
	hand_1.attack()
	hand_2.attack()

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
