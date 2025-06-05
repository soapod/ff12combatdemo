extends Node2D
class_name CombatEntity

# Enumeration for accessing stat dictionary keys. These are used as keys in the
# `stats` dictionary so the code remains readable.
enum Stat {
    HP,
    MAX_HP,
    MP,
    MAX_MP,
    STRENGTH,
    MAGIC,
    SPEED,
    VITALITY
}

# Base class for all combat participants (players and enemies). Child classes
# simply override stats and equipment.

# --- Identity & Vital Stats ---
var display_name: String = "Unnamed"
var level: int = 1
var stats: Dictionary = {
        Stat.HP: 100,
        Stat.MAX_HP: 100,
        Stat.MP: 0,
        Stat.MAX_MP: 0,
        Stat.STRENGTH: 10,
        Stat.MAGIC: 10,
        Stat.SPEED: 10,
        Stat.VITALITY: 10
}

# --- Equipment ---
var weapon: Weapon = null
var armor: Resource = null        # Placeholder: future Armor system
var accessory: Resource = null    # Placeholder: future Accessory system

# --- Combat State ---
var ct: float = 0.0               # Charge Time (0-100). At 100 the entity acts.
var is_ready: bool = false        # True once CT reaches 100
var is_alive: bool = true         # False when HP drops to zero

# Called every frame by the BattleManager to increment CT based on SPEED
func update_ct(delta: float) -> void:
	if not is_alive:
		return

        var speed = stats.get(Stat.SPEED, 10)
	ct += delta * speed

	if ct >= 100.0:
		ct = 100.0
		is_ready = true

# Resets CT after an action is performed so the entity must charge again
func reset_ct() -> void:
	ct = 0.0
	is_ready = false

# Applies damage and handles death notification
func take_damage(amount: float) -> void:
        stats[Stat.HP] -= amount
        if stats[Stat.HP] <= 0:
                stats[Stat.HP] = 0
		is_alive = false
		# TODO: Handle death animation or removal if needed
		
		# Log death to battle log
		var battle_manager = get_tree().get_current_scene().get_node("BattleManager")
		if battle_manager and battle_manager.has_method("log_action"):
			battle_manager.log_action("%s has fallen!" % display_name)
			
# Performs a weapon attack. Can chain multiple hits if the weapon's combo
# chance succeeds.
func perform_attack(target: CombatEntity) -> void:
	if weapon == null or not target.is_alive:
		return

	var combo_count = 1

	while true:
		var weapon_power = weapon.power
                var base = (weapon_power * (stats.get(Stat.STRENGTH, 10) + level)) / 2.0
		var variance = randf_range(1.0, 1.125)
		var damage = base * variance

		# Critical hit check
		var is_crit = false
		if randf() < weapon.crit_chance:
			damage *= weapon.crit_multiplier
			is_crit = true

		target.take_damage(damage)

                # Log the attack details to the battle log
		var log_text = "%s hits %s for %d%s (Hit %d)" % [
			display_name,
			target.display_name,
			damage,
			" CRITICAL!" if is_crit else "",
			combo_count
		]

		var battle_manager = get_tree().get_current_scene().get_node("BattleManager")
		if battle_manager and battle_manager.has_method("log_action"):
			battle_manager.log_action(log_text)

		if not target.is_alive:
			break

		# Combo continuation check
		if randf() > weapon.combo_chance:
			break

		combo_count += 1

# Wraps an attack into a CombatAction resource for the BattleManager
func generate_attack_action(target: CombatEntity) -> CombatAction:
	var action = CombatAction.new()
	action.source = self
	action.target = target
	action.type = CombatAction.ActionType.ATTACK
	return action
