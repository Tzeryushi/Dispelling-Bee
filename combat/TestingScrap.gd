extends AnimatedSprite

onready var tween = $Tween

func play_inter(defender:Vector2) -> void:
#	var tween = Tween.new()
#	add_child(tween)
	tween.interpolate_property(self, "position", get_position(), defender, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	print("why")
