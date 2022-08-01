extends Node2D

export var accel := 400.0

var velocity := 0
var direction := Vector2(1.0,-1.0)

onready var _animation := $AnimationPlayer
onready var _collision := $Area2D
onready var _particles := $Particles2D

func _ready() -> void:
	_collision.connect("body_entered", self, "_on_Area_body_entered")
	_particles.emitting = false
	_particles.one_shot = true
	pass
	
func _physics_process(delta: float) -> void:
	velocity += accel * delta
	position += direction * velocity * delta


func _on_Area_body_entered(body) -> void:
	_animation.play("Collision")
