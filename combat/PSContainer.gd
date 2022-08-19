extends Node2D

onready var text_box = $PSpellText 
onready var bubble = $Bubble

export var bg_color : Color = Color (0,0,1,1)
export var bubble_min = 100.0
export var notice_init = Vector2(131, 25)
export var notice_jump_dist = 100.0
export var notice_timer = 1.0
export var honey_notice : PackedScene

var bubble_height
var bubble_width
var cached_text : String
var text_width

func _ready() -> void:
	bubble.modulate = bg_color
	text_width = text_box.rect_size.x
	bubble_height = bubble.texture.get_height()
	bubble_width = bubble.texture.get_width()
	bubble.position = Vector2(get_parent().get_position().x + (bubble_width/2), get_parent().get_position().y+(bubble_height/2))
#	bubble.rect_size.x = text_width + 200

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
#	var rect_size = height + 80.0
#	rect_size = max(bubble_min, rect_size)
#	bubble.rect_size.y = rect_size
	text_box.set_position(Vector2(text_box.get_position().x, (bubble_height/2) - (height/2)))

func flash_honey_notice() -> void:
	var notice = honey_notice.instance()
	add_child(notice)
	move_child(notice, 0)
	notice.rect_position = notice_init
	var tween = create_tween()
	var new_pos = notice.rect_position + Vector2(0, -notice_jump_dist)
	yield(tween.tween_property(notice, "rect_position", new_pos, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT), "finished")
	tween = create_tween()
	yield(tween.tween_property(notice, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT), "finished")
	notice.queue_free()
	

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
