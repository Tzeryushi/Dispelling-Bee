extends SpellAnimation

onready var projectile = $Projectile
onready var enemy = $EnemyCollision


export var spell_speed : float = 500.0
export var rotation_force : float = 50
export var max_speed : float = 1000.0

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
	var dir_choice = randi()%2
	if dir_choice == 0:
		direction = Vector2(direction.x*cos(rand_range(-PI/3,-PI/6))-direction.y*sin(rand_range(-PI/3,-PI/6)), direction.x*sin(rand_range(-PI/3,-PI/6))+direction.y*cos(rand_range(-PI/3,-PI/6)))
	else:
		direction = Vector2(direction.x*cos(rand_range(PI/6,PI/3))-direction.y*sin(rand_range(PI/6,PI/3)), direction.x*sin(rand_range(PI/6,PI/3))+direction.y*cos(rand_range(PI/6,PI/3)))
	velocity = direction * spell_speed*2
	play_through = true
	
func accel() -> Vector2:
	var direction = (enemy.position - projectile.position).normalized() * spell_speed
	direction = (direction - velocity).normalized() * rotation_force
	return direction

func _on_Projectile_area_entered(area):
	emit_signal("hit")
	emit_signal("finished")
	queue_free()
