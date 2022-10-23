extends Button

signal button_combat(enemy)

onready var arrow := $Center
onready var sprite := $Sprite
onready var back_circle := $Sprite/BackCircle

#export(Texture) var image
export(PackedScene) var enemy_scene = preload("res://combat/HatWizard.tscn")
export var back_color : Color = Color(0.0, 0.0, 0.0, 0.5)
export var back_alt_color : Color = Color(0.0, 0.0, 0.8, 0.5)

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
	grab_focus()

func _hover_out() -> void:
	arrow.visible = false
	back_circle.set_and_draw(back_color)
