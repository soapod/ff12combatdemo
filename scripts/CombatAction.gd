extends RefCounted
class_name CombatAction

# Lightweight object representing a single combat action (e.g. attack or spell)

# Enumeration of possible action types
enum ActionType { ATTACK, SPELL, DEFEND }

# References to the entity performing the action and the target
var source: CombatEntity
var target: CombatEntity
var type: ActionType

# Executes the action based on its type. Only ATTACK is implemented for now.
func execute() -> void:
	match type:
		ActionType.ATTACK:
			source.perform_attack(target)
		ActionType.SPELL:
			# Placeholder for spell logic (to be implemented later)
			pass
		ActionType.DEFEND:
			# Placeholder for defend logic (to be implemented later)
			pass
