extends Node2D

onready var text_box = $SpellbookText
onready var spellbook = $Spellbook

export var bg_color : Color = Color (0,0,1,1)
export var spellbook_min = 100.0

var cached_text : String

func _ready() -> void:
	spellbook.modulate = bg_color
	spellbook.rect_size.y = spellbook_min

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	var rect_size = height + 80.0
	rect_size = max(spellbook_min, rect_size)
	spellbook.rect_size.y = rect_size
	text_box.margin_top = (rect_size/2) - (height/2)

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
