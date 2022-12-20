extends DefaultWizardSprite

onready var player = $Pos/AnimationPlayer
onready var swap_se = $SwapNoise

var symmetric := true

func attack() -> void:
	if symmetric:
		player.play("Attack")
		yield(player, "animation_finished")
		player.play("Idle")
	else:
		player.play("OffAttack")
		yield(player, "animation_finished")
		player.play("OffKilterIdle")
	
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
		player.play("OffHurt")
		yield(player, "animation_finished")
		player.play("OffKilterIdle")

func channel() -> void:
	print(symmetric)
	if symmetric:
		player.play("IdleSwitch")
		yield(player, "animation_finished")
		player.play("Idle")
	else:
		player.play("OffKilterStart")
		yield(player, "animation_finished")
		player.play("OffKilterIdle")

func swap_mode() -> void:
	symmetric = !symmetric
	swap_se.play()
	if symmetric:
		#set eye rotation to match with other eye
		$Pos/Body/Head/PupilR.change_rot_speed(1.0)
	else:
		#right eye rotates at different speed
		$Pos/Body/Head/PupilR.change_rot_speed(0.6)
		
func get_mode() -> bool:
	return symmetric

func lose() -> void:
	$Pos/Body/Head/PupilR.change_rot_speed(0.6)
	player.play("Lose")
	yield(player, "animation_finished")
	player.play("LoseLoop")
	
func win() -> void:
	pass
