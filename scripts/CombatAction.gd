# scripts/CombatAction.gd
extends Resource
class_name CombatAction

enum ActionType { ATTACK }

var action_type: ActionType
var source: CombatEntity
var target: CombatEntity
var payload := {}

func execute():
	if source and target and action_type == ActionType.ATTACK:
		source.perform_attack(target, payload)
