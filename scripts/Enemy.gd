# scripts/Enemy.gd
extends "res://scripts/CombatEntity.gd"

func _ready():
	display_name = "Wolf"
	level = 8
	stats = {
		"hp": 300,
		"max_hp": 300,
		"mp": 0,
		"max_mp": 0,
		"strength": 18,
		"magic": 0,
		"speed": 15,
		"vitality": 8
	}

func _process(delta):
	var hp_bar = get_node("HPBar")
	hp_bar.max_value = stats["max_hp"]
	hp_bar.value = stats["hp"]

	weapon = preload("res://data/Weapon_Claws.tres")
	armor = null
	accessory = null
