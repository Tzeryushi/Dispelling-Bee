extends Button

signal button_combat(enemy)

onready var arrow := $Center
onready var sprite := $Sprite
onready var back_circle := $Sprite/BackCircle
onready var check := $GreenCheck
onready var clear := $Clear

#export(Texture) var image
export(PackedScene) var enemy_scene = preload("res://combat/HatWizard.tscn")
export var back_color : Color = Color(0.0, 0.0, 0.0, 0.5)
export var back_alt_color : Color = Color(0.0, 0.0, 0.8, 0.5)

var clear_message = "[center][color=#00a5cf]Best Time:\n[rainbow]"

func _ready() :
	connect("pressed", self, "_button_pressed")
	connect("mouse_entered", self, "_hover_in")
	connect("mouse_exited", self, "_hover_out")
	connect("focus_entered", self, "_hover_in")
	connect("focus_exited", self, "_hover_out")
	#sprite.texture = image
	arrow.visible = false
	back_circle.set_and_draw(back_color)
	
func _button_pressed() -> void:
	
	emit_signal("button_combat", enemy_scene)

func _hover_in() -> void:
	arrow.visible = true
	back_circle.set_and_draw(back_alt_color)
	$Plink.play()
	grab_focus()

func _hover_out() -> void:
	arrow.visible = false
	back_circle.set_and_draw(back_color)

func set_clear(value:int) -> void:
	if value >= 5999999:
		clear.bbcode_text = clear_message+"99:59:999"
	else:
		var total : String
		var msecs = value%1000
		var secs = (value%(60*1000))/1000
		var mins = (value/(60*1000))%100
		total = "%02d:%02d:%03d" % [mins, secs, msecs]
		clear.bbcode_text = clear_message+total
