extends PanelContainer

onready var text_box = $PSpellText 

var cached_text : String

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	rect_size.y = height + 8

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
