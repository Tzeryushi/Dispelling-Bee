extends DefaultWizardSprite

onready var player = $Pos/AnimationPlayer

func attack() -> void:
	player.play("Attack")
	yield(player, "animation_finished")
	player.play("Idle")

func attack2() -> void:
	player.play("Attack2Cast")
	yield(player, "animation_finished")
	player.play("Idle")

func hurt() -> void:
	player.play("Hurt")
	yield(player, "animation_finished")
	player.play("Idle")

func dispelled() -> void:
	player.play("Dispelled")
	yield(player, "animation_finished")
	player.play("Idle")

func channel() -> void:
	player.play("Attack2")
	yield(player, "animation_finished")
	player.play("Attack2Channel")

func lose() -> void:
	player.play("LoseBegin")
	yield(player, "animation_finished")
	player.play("LoseLoop")
	
func win() -> void:
	pass
