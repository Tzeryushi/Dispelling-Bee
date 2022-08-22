extends SpellAnimation

onready var projectile = $Projectile
onready var enemy = $EnemyCollision


export var spell_speed : float = 5000.0
export var start_speed: float = 3000.0
export var max_speed : float = 500.0
export var float_out_time : float = 0.5

var velocity = Vector2.ZERO
var play_through = false
var float_out = false
var time_out = 0.0
var accrue = Vector2.ZERO
var start_vector = Vector2.ZERO

func _physics_process(delta) -> void:
	if float_out:
		var direction = (enemy.position - projectile.position).normalized()
		velocity -= start_vector*8000*delta
		velocity += direction * spell_speed * delta
		projectile.position += velocity * delta
		time_out += delta
		if time_out >= float_out_time:
			print("swap")
			play_through = true
			float_out = false
	if play_through:
		var distance = (enemy.position - projectile.position).length()
		var direction = (enemy.position - projectile.position).normalized()
		velocity += (direction * spell_speed * delta)*(time_out*10)
		projectile.position += velocity * delta
		time_out += delta
#	if float_out:
#		velocity += accel()
#		projectile.position += velocity * delta
#		time_out += delta
#		if time_out >= float_out_time:
#			play_through = true
#			float_out = false
#	elif play_through:
#		accrue += accel()*0.1
#		velocity += accel() + accrue
#		print(velocity.length())
#		projectile.position += velocity * delta
#		time_out += delta
#		acceleration += accel()
#		velocity += acceleration * delta
#		velocity = velocity.clamped(max_speed)
#		#projectile.rotation = velocity.angle()
#		projectile.position += velocity * delta

func _play(attacker, defender) -> void:
	projectile.position = attacker.position
	enemy.position = defender.get_global_position()
	var direction = (enemy.position - projectile.position).normalized()
	var dir_choice = randi()%2
	if dir_choice == 0:
		direction = Vector2(direction.x*cos(rand_range(-PI/4,-PI/6))-direction.y*sin(rand_range(-PI/3,-PI/6)), direction.x*sin(rand_range(-PI/3,-PI/6))+direction.y*cos(rand_range(-PI/3,-PI/6)))
	else:
		direction = Vector2(direction.x*cos(rand_range(PI/6,PI/4))-direction.y*sin(rand_range(PI/6,PI/3)), direction.x*sin(rand_range(PI/6,PI/3))+direction.y*cos(rand_range(PI/6,PI/3)))
	start_vector = direction.normalized()
	velocity = direction * start_speed
	float_out = true
	
#func accel() -> Vector2:
#	if play_through:
#		var direction = (enemy.position - projectile.position).normalized() * spell_speed
#		direction = (direction - velocity).normalized() * rotation_force
#		return direction
#	var direction = (enemy.position - projectile.position).normalized() * spell_speed
#	direction = (direction - velocity).normalized() * rotation_force
#	return direction

func _on_Projectile_area_entered(area):
	emit_signal("hit")
	emit_signal("finished")
	queue_free()
