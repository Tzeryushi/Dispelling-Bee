extends SpellAnimation

onready var projectile = $Projectile
onready var enemy = $EnemyCollision

export var spell_speed : float = 700.0
export var rotation_force : float = 100
export var max_speed : float = 100000.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var play_through = false

func _physics_process(delta) -> void:
	if play_through:
		acceleration += accel()
		velocity += acceleration * delta
		velocity = velocity.clamped(spell_speed)
		projectile.rotation = velocity.angle()
		projectile.position += velocity * delta

func _play(attacker, defender) -> void:
	projectile.position = attacker.position
	enemy.position = defender.get_global_position()
	var direction = (enemy.position - projectile.position).normalized()
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
	direction = Vector2(direction.x*cos(rand_range(-PI/4,PI/4))-direction.y*sin(rand_range(-PI/4,PI/4)), direction.x*sin(rand_range(-PI/4,PI/4))+direction.y*cos(rand_range(-PI/4,PI/4)))
	velocity = direction * max_speed
	play_through = true
	
func accel() -> Vector2:
	var direction = (enemy.position - projectile.position).normalized() * spell_speed
	direction = (direction - velocity).normalized() * rotation_force
	return direction

func _on_Projectile_area_entered(area):
	emit_signal("hit")
	emit_signal("finished")
	queue_free()
