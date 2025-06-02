# scripts/BattleManager.gd
extends Node

var combatants: Array = []            # All characters in the battle
var action_queue: Array = []          # Queue of CombatActions
var is_processing_action: bool = false

func _ready():
	# Locate the player and enemy nodes in the scene tree
	var player = get_node("../Player1")
	var enemy = get_node("../Enemy1")

	combatants = [player, enemy]
	print("Battle started between %s and %s" % [player.display_name, enemy.display_name])

func _process(delta: float) -> void:
	if is_processing_action:
		return

	# Update CT for each living character
	for entity in combatants:
		if entity.is_alive:
			entity.update_ct(delta)

			if entity.is_ready:
				var target = get_random_enemy_for(entity)
				if target:
					var action = entity.generate_attack_action(target)
					queue_action(action)
					entity.reset_ct()

	# Execute next action in the queue
	if action_queue.size() > 0:
		var action = action_queue.pop_front()
		is_processing_action = true
		action.execute()
		is_processing_action = false

func queue_action(action):
	action_queue.append(action)

func get_random_enemy_for(source):
	for entity in combatants:
		if entity != source and entity.is_alive:
			return entity
	return null

func log_action(text: String) -> void:
	var log_box = get_tree().get_current_scene().get_node("ActionLog")
	var template = log_box.get_node("LogTemplate")
	var new_entry = template.duplicate()
	new_entry.text = text
	new_entry.visible = true
	log_box.add_child(new_entry)
	log_box.move_child(new_entry, log_box.get_child_count() - 2)
