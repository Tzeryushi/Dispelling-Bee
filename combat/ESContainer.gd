extends PanelContainer

onready var text_box = $ESpellText
onready var bubble = $Bubble

export var bg_color : Color = Color (0,0,1,1)

var cached_text : String

func _ready() -> void:
	bubble.modulate = bg_color

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	rect_size.y = height + 40.0
	text_box.margin_top = (rect_size.y/2) - (height/2)
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	text_box.margin_top = (rect_size.y/2) - (height/2)
	
#	var clean_text = text_box.text
#	var sanitized = ""
#	for i in clean_text.split("\n"):
#		if i.length() > sanitized.length():
#			sanitized = i
#	var font = text_box.get_font("normal_font")
#	var size = font.get_string_size(sanitized)
#	rect_size.x = size.x + 16.0
#	rect_size.y = clean_text.split("\n").size() * size.y + 8.0
