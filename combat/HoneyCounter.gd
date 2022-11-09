extends Control
#shouldn't need to send signals from here

onready var count = $Count
onready var anim_tree = $AnimationTree
onready var honey_bar = $HoneyBar
onready var flash_honey = $FlashHoney

var current_count = 0
var max_count = 0 #for setting font red when count is full
var animation_state
var full := false

export var normal_color : Color = Color(1,1,1,1)
export var full_color : Color = Color (0,0,1,1)

signal honey_filled

func _ready() -> void:
	animation_state = anim_tree.get("parameters/playback")

func update_count(new_count) -> void:
	var old_full = full
	current_count = new_count
	full_check()
	if !old_full and full:
		emit_signal("honey_filled")
	count.text = String(new_count)
	var tween := create_tween()
	var target = (float(new_count)/float(max_count))*honey_bar.max_value
	tween.parallel().tween_property(honey_bar, "value", target, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func setup(new_max_count, new_count) -> void:
	current_count = new_count
	max_count = new_max_count
	update_count(current_count)

func update_max(new_max_count) -> void:
	max_count = new_max_count
	full_check()

func full_check() -> void:
	if current_count >= max_count:
		count.add_color_override("font_color", full_color)
		full = true
	else:
		count.add_color_override("font_color", normal_color)
		full = false

func shake() -> void:
	animation_state.travel("Shake")

func flash() -> void:
	$Notice.play()
	flash_honey.visible = true
	flash_honey.scale = Vector2(1.0, 1.0)
	flash_honey.modulate.a = 2.0
	var tween := create_tween()
	tween.tween_property(flash_honey, "scale", Vector2(5.0,5.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(flash_honey, "modulate:a", 0.0, 0.5)
	yield(tween, "finished")
	flash_honey.visible = false

func _on_CombatStats_honey_changed(_old_value, new_value):
	#received from CombatStats
	update_count(new_value)

func _on_CombatStats_honey_not_enough():
	shake()

func _on_CombatStats_honey_overfill():
	shake()
	flash()
