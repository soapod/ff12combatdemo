extends CombatEntity
class_name Enemy

# Represents an AI-controlled enemy combatant
# Inherits all base stats, CT, attack logic, etc. from CombatEntity

func _ready() -> void:
	display_name = "Enemy"
	level = 10

	# Example stats — override per enemy type or prefab
	stats = {
		"hp": 300,
		"max_hp": 300,
		"mp": 0,
		"max_mp": 0,
		"strength": 16,
		"magic": 8,
		"speed": 12,
		"vitality": 8
	}

	# Equip a weapon (adjust per enemy)
	weapon = preload("res://data/Weapon_Broadsword.tres")
	armor = null
	accessory = null

func _process(delta: float) -> void:
	# Simple real-time HP bar update
	var hp_bar = get_node("HPBar")
	hp_bar.max_value = stats["max_hp"]
	hp_bar.value = stats["hp"]
