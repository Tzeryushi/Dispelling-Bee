extends Node2D

onready var dialogue_area = $DialogueArea
onready var arrow = $DialogueArea/DialogueBox/NextPrompt
onready var portrait = $DialogueArea/Portrait
onready var dialogue_text = $DialogueArea/DialogueBox/Text
onready var speaker_name = $DialogueArea/DialogueBox/Name
onready var type_timer = $DialogueArea/DialogueBox/TypeTimer

onready var api_icon = $DialogueArea/ApiPortrait
onready var enemy_icon = $DialogueArea/EnemyPortrait

export var text_speed = 0.06
export var dialogue_dir : String = "res://dialogue/"
export var default_file : String = "Default0.json"
export var default_icon : Texture
export(Array, Texture) var enemy_icons 

var dialogue : Array
var text_num := 0
var text_done := false
var active := false

signal finished()

func _ready() -> void:
	api_icon.visible = false
	enemy_icon.visible = false
	arrow.visible = false
	dialogue_area.visible = false

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
			
func start_dialogue(identifier:String) -> void:
	text_num = 0
	text_done = false
	active = true
	dialogue_area.visible = true
	type_timer.wait_time = text_speed
	dialogue = load_dialogue(_find_dialogue(identifier))
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
	if data["Name"] == "Apicurio":
		api_icon.visible = true
		enemy_icon.visible = false
	else:
		api_icon.visible = false
		#set enemy icon
		var tex = default_icon
		if data.has("Icon"):
			tex = enemy_icons[data["Icon"]]
		enemy_icon.texture = tex
		enemy_icon.visible = true
	dialogue_text.bbcode_text = data["Text"]
	
	dialogue_text.visible_characters = 0
	while dialogue_text.visible_characters < dialogue_text.text.length():
		type_timer.start()
		yield(type_timer, "timeout")
		dialogue_text.visible_characters += 1
	
	text_done = true
	arrow.visible = true

func force_end() -> void:
	emit_signal("finished")
	active = false
	close_out()

func close_out() -> void:
	arrow.visible = false
	dialogue_area.visible = false
	
func _find_dialogue(identifier:String) -> String:
	var dir = Directory.new()
	if dir.open(dialogue_dir) == OK:
		var _filename = identifier + ".json"
		if dir.file_exists(_filename):
			return dialogue_dir + _filename
	return dialogue_dir + default_file
