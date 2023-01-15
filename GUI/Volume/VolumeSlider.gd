extends Node

onready var slider = $Control/VBoxContainer/HBoxContainer/VBoxContainer/VolumeSlider

func _ready():
	print("ready is called")
	var vol = AudioServer.get_bus_volume_db(0)
	slider.value = vol

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
