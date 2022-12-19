extends SpellAnimation

onready var player = $AnimationPlayer

func _play(attacker, defender) -> void:
	player.play("Slash")
	yield(player, "animation_finished")
	emit_signal("finished")

func hit() -> void:
	emit_signal("hit")
