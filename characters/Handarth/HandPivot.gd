extends Position2D

export var rotation_speed = 2.0
onready var hand = $Hand1

func _process(delta) -> void:
	rotation += rotation_speed * delta
	hand.global_rotation = 0

func attack() -> void:
	var tween = create_tween()
	var initial = position
	tween.tween_property(self, "position", position-Vector2(100, 50), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_method(self, "set_abb", 0.0, 5.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.tween_property(self, "position", initial, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_method(self, "set_abb", 5.0, 0.0, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func slow_rotation(time:float=2.0) -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_speed", 0.0, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func set_abb(value:float) -> void:
	hand.material.set_shader_param("amount", value)
