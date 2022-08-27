extends EnemySpells

func _ready() -> void:
	list.append({"Text":"Firebang!", "Tags":"[shake]", "Solve":"gnaberif!", "Damage":1, "Drain":1, "Speed":15, "Animation":0})
	list.append({"Text":"Fireboom!", "Tags":"[shake][wave]", "Solve":"mooberif!", "Damage":1, "Drain":1, "Speed":15, "Animation":0})
	list.append({"Text":"Big Ball o' Flame!", "Tags":"[rainbow]","Solve":"emalf o' llab gib!", "Damage":2, "Drain":2, "Speed":20, "Animation":0})
