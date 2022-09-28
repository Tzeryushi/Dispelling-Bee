extends Node2D

onready var image := $Pos/PlayerImage
onready var api_animation_state = $Pos/PlayerImage/ApiAnimationTree.get("parameters/playback")

func flash_color(color:Color, flash_time = 0.05, flashes = 2) -> void:
	var tween = create_tween()
	for _i in range(0, flashes):
		tween.tween_property(image, "modulate", color, flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "modulate", Color(1,1,1,1), flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func attack() -> void:
	api_animation_state.travel("casting")
	
func idle_loop() -> void:
	api_animation_state.travel("idle")

func pause() -> void:
	api_animation_state.travel("RESET")
