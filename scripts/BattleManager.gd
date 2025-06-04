extends Node
class_name BattleManager

# Orchestrates combat flow between all entities on the battlefield

# --- State ---
var combatants: Array = []           # All entities participating in combat
var action_queue: Array = []         # Queue of pending combat actions
var is_processing_action: bool = false

# Called when the scene is ready
func _ready() -> void:
	# Reference initial combatants (assumes fixed names in the scene tree)
	var player = get_parent().get_node("Player1")
	var enemy = get_parent().get_node("Enemy1")

	combatants = [player, enemy]

	# Initial log entry
	log_action("Battle started between %s and %s" % [
		player.display_name,
		enemy.display_name
	])

# Called every frame to manage combat flow
func _process(delta: float) -> void:
	if is_processing_action:
		return

	for entity in combatants:
		if entity.is_alive:
			entity.update_ct(delta)

			if entity.is_ready:
				var target = get_random_enemy_for(entity)
				if target:
					var action = entity.generate_attack_action(target)
					queue_action(action)
					entity.reset_ct()

	if action_queue.size() > 0:
		var action = action_queue.pop_front()
		is_processing_action = true
		action.execute()
		is_processing_action = false

# Adds a new action to the queue
func queue_action(action: CombatAction) -> void:
	action_queue.append(action)

# Returns a random valid enemy target for the given source entity
func get_random_enemy_for(source: CombatEntity) -> CombatEntity:
	for entity in combatants:
		if entity != source and entity.is_alive:
			return entity
	return null

# Logs text to the ActionLog UI element
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
	log_box.move_child(new_entry, log_box.get_child_count() - 2)
