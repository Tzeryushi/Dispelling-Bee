extends Resource

class_name PlayerSpells

#Spellbooks in the future?
#This is just an idea for a way to keep track of spells.
#As spells are simply referenced and not changed, and they can only
#be added to a player*, it makes sense to have them globally accessible.

export var list = {"PEW-PEW":{"Damage":1,"Honey":3}}

func add_spell(name:String, damage:int, cost:int) -> void:
	list[name]["Damage"] = damage
	list[name]["Honey"] = cost
