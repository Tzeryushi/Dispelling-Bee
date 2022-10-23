extends SpellAnimation

onready var player := $AnimationPlayer

func _play(attacker, defender) -> void:
	player.play("Spell")
	#spell animation emits hit signal
	yield(player, "animation_finished")
	emit_signal("finished")

func hit() -> void:
	emit_signal("hit")
