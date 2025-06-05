extends CombatEntity
class_name Enemy

# Represents an AI-controlled enemy combatant. All combat behaviour comes from
# `CombatEntity`; this script only defines default stats and equipment.

func _ready() -> void:
        # Basic identity and stats for this enemy type
        display_name = "Enemy"
	level = 10

	# Example stats — override per enemy type or prefab
        stats = {
                CombatEntity.Stat.HP: 300,
                CombatEntity.Stat.MAX_HP: 300,
                CombatEntity.Stat.MP: 0,
                CombatEntity.Stat.MAX_MP: 0,
                CombatEntity.Stat.STRENGTH: 16,
                CombatEntity.Stat.MAGIC: 8,
                CombatEntity.Stat.SPEED: 12,
                CombatEntity.Stat.VITALITY: 8
        }

	# Equip a weapon (adjust per enemy)
	weapon = preload("res://data/Weapon_Broadsword.tres")
	armor = null
	accessory = null

func _process(delta: float) -> void:
        # Update the HP bar every frame so players can see damage taken
        var hp_bar = get_node("HPBar")
        hp_bar.max_value = stats[CombatEntity.Stat.MAX_HP]
        hp_bar.value = stats[CombatEntity.Stat.HP]
