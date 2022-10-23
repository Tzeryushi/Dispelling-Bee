extends Node2D

onready var body = $Pos/Image
onready var hand_1 = $Pos/Image/HandPivot1
onready var hand_2 = $Pos/Image/HandPivot2
onready var player := $Pos/AnimationPlayer

func attack() -> void:
	hand_1.attack()
	hand_2.attack()

func hurt() -> void:
	player.play("Hurt")
	yield(player, "animation_finished")
	player.play("Idle")

func dispelled() -> void:
	player.play("Dispelled")
	yield(player, "animation_finished")
	player.play("Idle")
