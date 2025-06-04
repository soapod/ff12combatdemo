extends CombatEntity
class_name PlayerCharacter

# Represents a player-controlled character
# Inherits all stats, charge time, and attack logic from CombatEntity

func _ready() -> void:
	display_name = "Vaan"
	level = 12

	# Player stats — adjust per character
	stats = {
		"hp": 450,
		"max_hp": 450,
		"mp": 30,
		"max_mp": 30,
		"strength": 24,
		"magic": 12,
		"speed": 18,
		"vitality": 10
	}

	# Initial equipment (can later be swapped via UI or inventory system)
	weapon = preload("res://data/Weapon_Broadsword.tres")
	armor = null
	accessory = null

func _process(delta: float) -> void:
	# Simple real-time HP bar update
	var hp_bar = get_node("HPBar")
	hp_bar.max_value = stats["max_hp"]
	hp_bar.value = stats["hp"]
