extends DefaultWizardSprite

onready var player = $Pos/AnimationPlayer

var symmetric := true

func attack() -> void:
	if symmetric:
		player.play("Attack")
		yield(player, "animation_finished")
		player.play("Idle")
	else:
		player.play("Attack")
		yield(player, "animation_finished")
		player.play("Idle")
	
func attack2() -> void:
	player.play("Attack")
	yield(player, "animation_finished")
	player.play("Idle")

func hurt() -> void:
	if symmetric:
		player.play("Hurt")
		yield(player, "animation_finished")
		player.play("Idle")
	else:
		player.play("OffHurt")
		yield(player, "animation_finished")
		player.play("OffKilterIdle")

func dispelled() -> void:
	if symmetric:
		player.play("Hurt")
		yield(player, "animation_finished")
		player.play("Idle")
	else:
		player.play("Hurt")
		yield(player, "animation_finished")
		player.play("Idle")

func channel() -> void:
	player.play("OffKilterStart")
	yield(player, "animation_finished")
	player.play("OffKilterIdle")

func swap_mode() -> void:
	symmetric = !symmetric
	if symmetric:
		#set eye rotation to match with other eye
		$Pos/Body/Head/PupilR.change_rot_speed(1.0)
	else:
		#right eye rotates at different speed
		$Pos/Body/Head/PupilR.change_rot_speed(0.6)

func lose() -> void:
	pass
	
func win() -> void:
	pass
