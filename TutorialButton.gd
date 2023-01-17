extends TextureButton

onready var arrow := $Arrow

func _ready() :
	connect("mouse_entered", self, "_hover_in")
	connect("mouse_exited", self, "_hover_out")
	connect("focus_entered", self, "_hover_in")
	connect("focus_exited", self, "_hover_out")
	arrow.visible = false
	
func _hover_in() -> void:
	arrow.visible = true
	$Plink.play()
	grab_focus()

func _hover_out() -> void:
	arrow.visible = false
