extends RefCounted
class_name CombatAction

# Lightweight object describing something a combatant will do

# Enumeration of possible action types
enum ActionType {
		ATTACK,    # Standard weapon attack
		SPELL,     # Magical ability (not implemented)
		DEFEND     # Defensive stance (not implemented)
}

# References to the entity performing the action and the target
var source: CombatEntity
var target: CombatEntity
var type: ActionType

# Executes the action depending on `type`
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
