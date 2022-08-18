extends Node2D

onready var text_box = $SpellbookText
onready var cost_box = $SpellCost

var text_origin : Vector2
var cached_text : String

func _ready() -> void:
	text_origin = Vector2(text_box.get_position().x, text_box.get_position().y + (text_box.rect_size.y/2))

func set_text(text:String) -> void:
	text_box.bbcode_text = text
	if not get_tree() == null:
		yield(get_tree(), "idle_frame")
	var height = text_box.get_content_height()
	text_box.set_position(Vector2(text_origin.x, text_origin.y-(height/2)))
	
func set_cost(text:String) -> void:
	cost_box.bbcode_text = text

func change_text_color(color:Color) -> void:
	text_box.add_color_override("default_color", color)
