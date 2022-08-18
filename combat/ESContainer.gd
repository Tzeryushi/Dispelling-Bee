extends Node2D

onready var text_box = $ESpellText
onready var bubble = $Bubble

export var bg_color : Color = Color (0,0,1,1)
export var bubble_min = 100.0

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
	print(bubble_height)
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	#var rect_size = height + 80.0
	#rect_size = max(bubble_min, rect_size)
	#bubble.rect_size.y = rect_size
	text_box.set_position(Vector2(text_box.get_position().x, (bubble_height/2) - (height/2)))

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
