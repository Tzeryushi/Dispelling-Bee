extends Node2D

onready var text_box = $SpellbookText
onready var cost_box = $SpellCost
onready var book = $BookSprite
onready var shadow1 = $LittleHoneyShadow
onready var shadow2 = $LittleShadow
onready var honey_icon = $LittleHoney

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

func new_spell(text:String, close_time : float = 0.2) -> void:
	var tween = create_tween()
	var original_scale = book.scale
	yield(tween.tween_property(book, "scale", Vector2(1.2,1.2), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT), "finished")
	shadow1.visible = false; shadow2.visible = false; honey_icon.visible = false
	text_box.visible = false; cost_box.visible = false
	set_text(text)
	book.play("closed")
	book.scale += Vector2(0, 0.5)
	tween = create_tween()
	yield(tween.tween_property(book, "scale", original_scale, close_time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT), "finished")
	book.play("open")
	shadow1.visible = true; shadow2.visible = true; honey_icon.visible = true
	text_box.visible = true; cost_box.visible = true
