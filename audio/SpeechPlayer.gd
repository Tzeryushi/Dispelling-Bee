extends Node2D

export var speech_bank : Dictionary

func _ready() -> void:
	for i in get_children():
		speech_bank[i.name] = i
		print(i.name)

func lookup_and_queue(key:String) -> bool:
	#unsupported node names
	if key == ".":
		key = "period"
	elif key == ":":
		key = "colon"
	elif key == "/" or key == "\\":
		key = "slash"
	
	if speech_bank.has(key):
		speech_bank[key].play()
		return true
	return false