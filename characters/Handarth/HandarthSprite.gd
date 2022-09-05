extends Node2D

onready var body = $Pos/Image
onready var hand_1 = $Pos/Image/HandPivot1
onready var hand_2 = $Pos/Image/HandPivot2

func attack() -> void:
	hand_1.attack()
	hand_2.attack()
