extends NinePatchRect

#shouldn't need to send signals from here

onready var count = $Count
var current_count = 0
var max_count = 0 #for setting font red when count is full

export var normal_color : Color = Color(1,1,1,1)
export var full_color : Color = Color (1,0,0,1)

func update_count(new_count) -> void:
	current_count = new_count
	full_check()
	count.text = String(new_count)

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
	else:
		count.add_color_override("font_color", normal_color)

func _on_CombatStats_honey_changed(_old_value, new_value):
	#received from CombatStats
	update_count(new_value)
