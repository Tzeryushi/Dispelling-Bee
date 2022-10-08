extends Control

onready var arrow = $DialogueBox/NextPrompt
onready var portrait = $Portrait
onready var dialogue_text = $DialogueBox/Text
onready var speaker_name = $DialogueBox/Name
onready var type_timer = $DialogueBox/TypeTimer

export var text_speed = 0.06

var dialogue : Array
var text_num := 0
var text_done := false
var active := false

signal finished()

func _ready() -> void:
	arrow.visible = false
	visible = false

func _input(event):
	if active:
		if event.is_action_pressed("ui_accept"):
			if text_done:
				if text_num >= dialogue.size():
					emit_signal("finished")
					active = false
					close_out()
				else:
					next_text(dialogue[text_num])
					text_num += 1
			else:
				dialogue_text.visible_characters = dialogue_text.text.length()
			
func start_dialogue(path:String) -> void:
	text_num = 0
	text_done = false
	active = true
	visible = true
	type_timer.wait_time = text_speed
	dialogue = load_dialogue(path)
	next_text(dialogue[text_num])
	text_num += 1

func load_dialogue(dialogue_path:String) -> Array:
	var _file := File.new()
	var error := _file.open(dialogue_path, File.READ)
	if error != OK:
		printerr("Could not open %s. Error code %s" % [dialogue_path, error])
		return []
	
	var content := _file.get_as_text()
	_file.close()
	var parse = JSON.parse(content)
	if parse.error != OK:
		printerr("Icky JSON data. Error code %s" % [parse.error])
	var data = parse.result
	if typeof(data) == TYPE_ARRAY:
		return data
	else:
		return []

func next_text(data) -> void:
	if data == null:
		return
	arrow.visible = false
	text_done = false
	speaker_name.bbcode_text = data["Name"]
	dialogue_text.bbcode_text = data["Text"]
	
	dialogue_text.visible_characters = 0
	while dialogue_text.visible_characters < dialogue_text.text.length():
		type_timer.start()
		yield(type_timer, "timeout")
		dialogue_text.visible_characters += 1
	
	text_done = true
	arrow.visible = true

func close_out() -> void:
	arrow.visible = false
	visible = false
