# scripts/CombatEntity.gd
extends Node
class_name CombatEntity

# --- Identity & Basics ---
var display_name: String = "Unnamed"
var level: int = 1

# --- Core Stats ---
var stats := {
	"hp": 100,
	"max_hp": 100,
	"mp": 30,
	"max_mp": 30,
	"strength": 10,
	"magic": 10,
	"speed": 10,
	"vitality": 10
}

# --- Equipment placeholders ---
var weapon: Resource = null
var armor: Resource = null
var accessory: Resource = null

# --- Buffs / Status Effects ---
var buffs := {}            # e.g. { "haste": true }
var status_effects := {}   # e.g. { "blind": true }

# --- Combat Timing ---
var ct_timer: float = 0.0
var ct_required: float = 3.5
var ct_speed_multiplier: float = 1.0
var is_ready: bool = false
var is_alive: bool = true

# --- Charge Time Update ---
func update_ct(delta: float) -> void:
	if not is_alive:
		return

	var speed = stats.get("speed", 10)
	var speed_factor = 100.0 / (100.0 + speed)
	ct_timer += delta * ct_speed_multiplier * speed_factor

	if ct_timer >= ct_required:
		is_ready = true

func reset_ct() -> void:
	ct_timer = 0.0
	is_ready = false

# --- Defense Accessor ---
func get_total_defense() -> int:
	return armor.defense if armor != null and armor.has("defense") else 0

# --- Damage Logic ---
func take_damage(amount: int) -> void:
	stats["hp"] = max(0, stats["hp"] - amount)
	if stats["hp"] <= 0:
		die()

func heal(amount: int) -> void:
	stats["hp"] = min(stats["max_hp"], stats["hp"] + amount)

func die() -> void:
	is_alive = false
	print("%s has been defeated." % display_name)

# --- Basic Attack with Combo Support ---
func perform_attack(target: CombatEntity, payload := {}) -> void:
	if not is_alive or not target.is_alive:
		return

	var combo_enabled = payload.has("combo_enabled") and payload["combo_enabled"]
	var combo_count = 0
	var keep_going = true
	var max_hits = 12

	while keep_going and combo_count < max_hits and target.is_alive:
		combo_count += 1

		var weapon_power = weapon.power if weapon != null else 10
		var combo_rate = weapon.combo_chance if weapon != null else 0.0
		combo_rate += 0.01 * (stats.get("speed", 10) / 10.0)

		var base_damage = (weapon_power * (stats.get("strength", 10) + level)) / 2.0
		var variance = randf_range(1.0, 1.125)
		var damage = base_damage * variance
		
		# 🔥 Critical hit?
		var is_crit = false
		if weapon != null and randf() < weapon.crit_chance:
			damage *= weapon.crit_multiplier
			is_crit = true
			
		damage -= target.get_total_defense()
		target.take_damage(max(1, round(damage)))
		
		# 📝 Log it to the screen
		var log_text = "%s hits %s for %d%s (Hit %d)" % [display_name,target.display_name,damage," CRITICAL!" if is_crit else "",combo_count]
		var battle_manager = get_tree().get_current_scene().get_node("BattleManager")
		if battle_manager and battle_manager.has_method("log_action"):
			battle_manager.log_action(log_text)

		
		if not combo_enabled:
			break
		keep_going = randf() < combo_rate

	print("Combo ended after %d hit(s)." % combo_count)

# --- Generate CombatAction (used by BattleManager) ---
func generate_attack_action(target: CombatEntity) -> CombatAction:
	var action = CombatAction.new()
	action.action_type = CombatAction.ActionType.ATTACK
	action.source = self
	action.target = target
	action.payload = { "combo_enabled": true }
	return action
