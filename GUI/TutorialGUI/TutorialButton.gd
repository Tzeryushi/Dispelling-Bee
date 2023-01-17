extends TextureButton

func _ready() :
	connect("mouse_entered", self, "_hover_in")
	connect("mouse_exited", self, "_hover_out")
	connect("focus_entered", self, "_hover_in")
	connect("focus_exited", self, "_hover_out")
	
func _hover_in() -> void:
	$Plink.play()
	#grab_focus()

func _hover_out() -> void:
	pass
