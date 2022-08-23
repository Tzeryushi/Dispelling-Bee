extends SpellAnimation

onready var projectile = $Projectile
onready var enemy = $EnemyCollision
onready var line = $Line2D

export var trail_length = 25

export var spell_speed : float = 5000.0
export var start_speed: float = 3500.0
export var float_out_time : float = 0.5
export var desired_distance : float = 450.0

var velocity = Vector2.ZERO
var init_decel = Vector2.ZERO
var play_through = false
var float_out = false
var time_out = 0.0
var accrue = Vector2.ZERO
var start_vector = Vector2.ZERO

var hit : bool = false

func _process(delta) -> void:
	if !hit:
		var point = projectile.position
		line.add_point(point)
		while line.get_point_count() > trail_length:
			line.remove_point(0)
	if line.get_point_count() == 0:
		emit_signal("finished")
		queue_free()
	elif hit:
		line.remove_point(0)

func _physics_process(delta) -> void:
	if float_out:
		var direction = (enemy.position - projectile.position).normalized()
		velocity += start_vector*init_decel*delta
		velocity += direction * spell_speed * delta
		projectile.position += velocity * delta
		time_out += delta
		if time_out >= float_out_time:
			play_through = true
			float_out = false
	if play_through:
		var distance = (enemy.position - projectile.position).length()
		var direction = (enemy.position - projectile.position).normalized()
		velocity += (direction * spell_speed * delta)*(time_out*10)
		projectile.position += velocity * delta
		time_out += delta

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
	init_decel = (((desired_distance - (velocity.length()*float_out_time))*2)/(float_out_time*float_out_time))
	float_out = true

func _on_Projectile_area_entered(area):
	emit_signal("hit")
	hit = true
	float_out = false
	play_through = false
	projectile.queue_free()
