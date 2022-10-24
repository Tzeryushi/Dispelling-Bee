extends Node2D

export var negative_color : Color = Color(1.0, 0, 0, 1.0)
export var positive_color : Color = Color(0, 1.0, 0, 1.0)
export var null_color : Color = Color(0.5, 0.5, 0.5, 1.0)

export var pop_scene : PackedScene

func popup(value:int, pos:Vector2) -> void:
	#set and call the instance at the location
	var output = "[color=#"
	if value < 0:
		output += negative_color.to_html(false) + "]"
	elif value > 0:
		output += positive_color.to_html(false) + "]+"
	else:
		output += null_color.to_html(false) + "]"
	var pop = pop_scene.instance()
	add_child(pop)
	pop.set_text(output+str(value))
	pop.set_position(pos)
	
	var tween = create_tween()
	yield(tween.tween_property(pop, "modulate:a", 0.0, 0.9).set_ease(Tween.EASE_OUT), "finished")
	pop.queue_free()
