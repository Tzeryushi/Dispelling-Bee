extends PanelContainer

onready var text_box = $PSpellText 
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
	rect_size.y = height + 80.0
	text_box.margin_top = (rect_size.y/2) - (height/2)
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	text_box.margin_top = (rect_size.y/2) - (height/2)

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
