extends SpellAnimation

onready var projectile = $Projectile

export var spell_accel : float = 1.0
export var rotation_force : float = 1.0

var play_through = false

func _process(delta) -> void:
	if play_through:
		return

func _play(attacker, defender) -> void:
	projectile.position = attacker.position
	play_through = true
