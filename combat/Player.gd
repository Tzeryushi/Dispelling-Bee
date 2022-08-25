extends Node2D

onready var image := $Pos/PlayerImage

func flash_color(color:Color, flash_time = 0.5, flashes = 2) -> void:
	var tween = create_tween()
	for i in range(0, flashes):
		print("loop")
		tween.tween_property(image, "modulate", color, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "modulate", Color(1,1,1,1), 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
