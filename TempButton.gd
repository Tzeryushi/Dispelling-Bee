extends Button

signal button_combat(enemy)

onready var arrow := $Center
onready var sprite := $Sprite

#export(Texture) var image
export(PackedScene) var enemy_scene = preload("res://combat/HatWizard.tscn")

func _ready() :
	connect("pressed", self, "_button_pressed")
	connect("mouse_entered", self, "_hover_in")
	connect("mouse_exited", self, "_hover_out")
	#sprite.texture = image
	arrow.visible = false
	
func _button_pressed() -> void:
	emit_signal("button_combat", enemy_scene)

func _hover_in() -> void:
	arrow.visible = true

func _hover_out() -> void:
	arrow.visible = false
