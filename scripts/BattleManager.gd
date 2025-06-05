extends Node
class_name BattleManager

# Main coordinator for combat actions and entity charge times

# --- State ---
# List of all CombatEntity nodes currently participating in battle
var combatants: Array = []
# Actions waiting to be executed in the order they were queued
var action_queue: Array = []
# Basic state machine for pausing updates while an action plays out
enum State { IDLE, PROCESSING }    # IDLE = waiting for CT to fill, PROCESSING = executing an action
var state: State = State.IDLE

# Called once when the scene tree is fully loaded
func _ready() -> void:
		# Grab the combatant nodes from the scene. This demo assumes the names are fixed.
		var player = get_parent().get_node("Player1")
		var enemy = get_parent().get_node("Enemy1")

		combatants = [player, enemy]      # Order is not important in this demo

		# Announce the start of battle in the on-screen log
		log_action("Battle started between %s and %s" % [
				player.display_name,
				enemy.display_name
		])

# Called every frame to update CT gauges and perform actions when ready
func _process(delta: float) -> void:
		if state == State.PROCESSING:
				return

		# Fill CT for each living combatant
		for entity in combatants:
				if entity.is_alive:
						entity.update_ct(delta)

						# When CT reaches 100 the entity can perform an action
						if entity.is_ready:
								var target = get_random_enemy_for(entity)
								if target:
										var action = entity.generate_attack_action(target)
										queue_action(action)
										entity.reset_ct()

		# Execute the next queued action, one at a time
		if action_queue.size() > 0:
				var action = action_queue.pop_front()
				state = State.PROCESSING
				action.execute()
				state = State.IDLE

# Adds a new action to the end of the queue
func queue_action(action: CombatAction) -> void:
		action_queue.append(action)

# Simple targeting helper used by the demo AI
# Returns the first living enemy found for the given source entity
func get_random_enemy_for(source: CombatEntity) -> CombatEntity:
		for entity in combatants:
				if entity != source and entity.is_alive:
						return entity
		return null

# Adds a labelled message to the UI element named "ActionLog"
func log_action(text: String) -> void:
	var log_box = get_tree().get_current_scene().get_node("ActionLog")
	if not log_box:
		return

	var template = log_box.get_node("LogTemplate")
	if not template:
		return

		var new_entry = template.duplicate()
		new_entry.text = text
		new_entry.visible = true

		log_box.add_child(new_entry)
		# Insert above the template so the newest entry appears last
		log_box.move_child(new_entry, log_box.get_child_count() - 2)
