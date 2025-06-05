extends Node2D
class_name CombatEntity

# Enumeration for accessing stat dictionary keys
# Each derived class can override these values in the `stats` dictionary
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

# Base class for all combat participants (players and enemies)

# --- Identity & Vital Stats ---
var display_name: String = "Unnamed"
var level: int = 1
# Dictionary containing all mutable stats for this entity
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
var weapon: Weapon = null          # Determines attack power and combo stats
var armor: Resource = null        # Placeholder: future Armor system
var accessory: Resource = null    # Placeholder: future Accessory system

# --- Combat State ---
var ct: float = 0.0               # Charge Time
var is_ready: bool = false
var is_alive: bool = true

# Increases CT each frame based on the entity's speed stat
# When CT reaches 100 the entity becomes ready to act
func update_ct(delta: float) -> void:
	if not is_alive:
		return

	var speed = stats.get(Stat.SPEED, 10)
	ct += delta * speed

	if ct >= 100.0:
		ct = 100.0
		is_ready = true

# Called after performing an action to start charging again
func reset_ct() -> void:
		ct = 0.0
		is_ready = false

# Decreases HP and checks for defeat
func take_damage(amount: float) -> void:
	stats[Stat.HP] -= amount
	if stats[Stat.HP] <= 0:
		stats[Stat.HP] = 0
		is_alive = false
		# TODO: Handle death animation or removal if needed
		
			
# Calculates damage and applies it to the target. May chain multiple hits
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


		if not target.is_alive:
			break

		# Combo continuation check
		# Random chance to keep attacking with the same weapon
		if randf() > weapon.combo_chance:
			break

		combo_count += 1

# Helper to create a CombatAction that represents a basic attack
func generate_attack_action(target: CombatEntity) -> CombatAction:
	var action = CombatAction.new()
	action.source = self
	action.target = target
	action.type = CombatAction.ActionType.ATTACK
	return action
