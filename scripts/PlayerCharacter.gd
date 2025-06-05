extends CombatEntity
class_name PlayerCharacter

# Represents a player-controlled character
# Inherits all stats, charge time, and attack logic from CombatEntity

func _ready() -> void:
	display_name = "Vaan"
	level = 12

	# Player stats — adjust per character
	stats = {
		CombatEntity.Stat.HP: 450,
		CombatEntity.Stat.MAX_HP: 450,
		CombatEntity.Stat.MP: 30,
		CombatEntity.Stat.MAX_MP: 30,
		CombatEntity.Stat.STRENGTH: 24,
		CombatEntity.Stat.MAGIC: 12,
		CombatEntity.Stat.SPEED: 18,
		CombatEntity.Stat.VITALITY: 10
		}

	# Initial equipment (can later be swapped via UI or inventory system)
	weapon = preload("res://data/Weapon_Broadsword.tres")
	armor = null
	accessory = null

func _process(delta: float) -> void:
	# Simple real-time HP bar update
	var hp_bar = get_node("HPBar")
	hp_bar.max_value = stats[CombatEntity.Stat.MAX_HP]
	hp_bar.value = stats[CombatEntity.Stat.HP]
