# scripts/PlayerCharacter.gd
extends "res://scripts/CombatEntity.gd"

func _ready():
	display_name = "Vaan"
	level = 12
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

func _process(delta):
	var hp_bar = get_node("HPBar")
	hp_bar.max_value = stats["max_hp"]
	hp_bar.value = stats["hp"]

	weapon = preload("res://data/Weapon_Broadsword.tres")
	armor = null
	accessory = null
