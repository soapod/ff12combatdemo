extends Resource
class_name Weapon

# Represents a weapon resource that can be equipped by a combatant
# Influences damage, critical hits, and combo chance

# Enumeration of the possible weapon categories. These will later control
# which damage formula gets used for an attack.
enum WeaponType {
                UNARMED,
                ONE_HANDED_SWORD,
                TWO_HANDED_SWORD,
                SPEAR,
                CROSSBOW,
                ROD,
                POLE,
                MACE,
                KATANA,
                STAVE,
                AXE,
                HAMMER,
                HAND_BOMB,
                DAGGER,
                NINJA_SWORD,
                BOW,
                GUN,
                MEASURE
                }

@export var name: String = "Basic Sword"    # Display name

@export var weapon_type: WeaponType = WeaponType.ONE_HANDED_SWORD  # Category of the weapon

@export var power: float = 10.0           # Base weapon power used in attack formulas
@export var crit_chance: float = 0.05     # Chance to land a critical hit (e.g. 5%)
@export var crit_multiplier: float = 1.5  # Multiplier applied to damage if critical hit lands
@export var combo_chance: float = 0.1     # Chance to chain another hit in a combo sequence
