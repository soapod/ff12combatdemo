extends Resource
class_name Weapon

# Represents a weapon resource that can be equipped by a combatant. The values
# here influence damage formulas and whether extra hits occur.

@export var name: String = "Basic Sword"

@export var power: float = 10.0           # Base weapon power used in attack formulas
@export var crit_chance: float = 0.05     # Chance to land a critical hit (e.g. 5%)
@export var crit_multiplier: float = 1.5  # Multiplier applied to damage if a critical hit lands
@export var combo_chance: float = 0.1     # Chance to chain another hit in a combo sequence
