extends PanelContainer

onready var text_box = $ESpellText 

var cached_text : String

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	rect_size.y = height
	
#	var clean_text = text_box.text
#	var sanitized = ""
#	for i in clean_text.split("\n"):
#		if i.length() > sanitized.length():
#			sanitized = i
#	var font = text_box.get_font("normal_font")
#	var size = font.get_string_size(sanitized)
#	rect_size.x = size.x + 16.0
#	rect_size.y = clean_text.split("\n").size() * size.y + 8.0
