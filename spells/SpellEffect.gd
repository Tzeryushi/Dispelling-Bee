extends Node2D

export var accel := 400.0

var velocity := 100.0
var direction := Vector2(1.0,-1.0)

onready var _animation := $AnimationPlayer
onready var _collision := $Area2D

func ready() -> void:
	_collision.connect("body_entered", self, "_on_Area_body_entered")
	
func _physics_process(delta: float) -> void:
	position += direction * ((velocity * delta) + (0.5 * accel * pow(delta, 2)))


func _on_Area2D_body_entered(body) -> void:
	print("wtf")
	_animation.play("Collision")
