extends Node2D

onready var text_box = $ESpellText
onready var bubble = $Bubble

export var bg_color : Color = Color (0,0,1,1)
export var bubble_min = 100.0

export var pop_text : PackedScene
export var pop_jump_dist = 200.0
export var pop_scale = 2.0

export var dead_text : PackedScene

var bubble_height
var bubble_width
var cached_text : String

func _ready() -> void:
	bubble.modulate = bg_color
	bubble_height = bubble.texture.get_height()
	bubble_width = bubble.texture.get_width()
	#bubble.position = Vector2(get_parent().get_position().x + (bubble_width/2), get_parent().get_position().y+(bubble_height/2))
	#bubble.rect_size.y = bubble_min

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	#var rect_size = height + 80.0
	#rect_size = max(bubble_min, rect_size)
	#bubble.rect_size.y = rect_size
	text_box.set_position(Vector2(text_box.get_position().x, (bubble_height/2) - (height/2)))

func pop_up_text() -> void:
	var popper = pop_text.instance()
	add_child(popper)
	popper.rect_position = text_box.rect_position
	var tween = create_tween()
	popper.bbcode_text = text_box.bbcode_text
	var new_pos = popper.rect_position + Vector2(0, pop_jump_dist)
	yield(tween.parallel().tween_property(popper, "rect_position", new_pos, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT), "finished")
	tween = create_tween()
	yield(tween.tween_property(popper, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT), "finished")
	popper.queue_free()

func dead_down_text() -> void:
	var deader = dead_text.instance()
	add_child(deader)
	deader.rect_position = text_box.rect_position
	deader.bbcode_text = "[center]" + text_box.text
	deader.add_color_override("default_color", Color(0.1,0.1,0.1,1.0))
	var tween = create_tween()
	yield(tween.tween_property(deader, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT), "finished")
	deader.queue_free()

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
	
func push_bb_color(color:Color) -> void:
	text_box.push_color(color)
#	var clean_text = text_box.text
#	var sanitized = ""
#	for i in clean_text.split("\n"):
#		if i.length() > sanitized.length():
#			sanitized = i
#	var font = text_box.get_font("normal_font")
#	var size = font.get_string_size(sanitized)
#	rect_size.x = size.x + 16.0
#	rect_size.y = clean_text.split("\n").size() * size.y + 8.0
