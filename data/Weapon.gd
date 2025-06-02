# data/Weapon.gd
extends Resource
class_name Weapon

@export var name: String = "Unnamed Weapon"
@export var power: int = 10
@export var combo_chance: float = 0.05
@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 1.5
