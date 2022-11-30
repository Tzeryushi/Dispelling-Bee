extends DefaultWizardSprite

onready var player = $Pos/AnimationPlayer

func attack() -> void:
	player.play("Attack")
	yield(player, "animation_finished")
	player.play("Idle")
	
func attack2() -> void:
	player.play("Attack")
	yield(player, "animation_finished")
	player.play("Idle")

func hurt() -> void:
	player.play("Hurt")
	yield(player, "animation_finished")
	player.play("Idle")

func dispelled() -> void:
	pass

func channel() -> void:
	pass

func lose() -> void:
	pass
	
func win() -> void:
	pass
