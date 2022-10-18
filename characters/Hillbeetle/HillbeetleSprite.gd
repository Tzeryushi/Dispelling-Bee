extends DefaultWizardSprite

onready var player = $Pos/AnimationPlayer

func attack() -> void:
	player.play("Attack")
	yield(player, "animation_finished")
	player.play("Idle")

func attack2() -> void:
	pass
