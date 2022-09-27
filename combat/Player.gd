extends Node2D

onready var image := $Pos/PlayerImage

func flash_color(color:Color, flash_time = 0.05, flashes = 2) -> void:
	var tween = create_tween()
	for _i in range(0, flashes):
		tween.tween_property(image, "modulate", color, flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "modulate", Color(1,1,1,1), flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func attack() -> void:
	pass
	
func idle_loop() -> void:
	pass
