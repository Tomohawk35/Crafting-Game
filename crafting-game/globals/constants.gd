extends Node
class_name Constants

enum ItemQuality { BROKEN, BATTERED, WORN, NORMAL, STURDY, EXCEPTIONAL, IMMACULATE }
enum ItemType { WEAPON, BODY_ARMOR, SHIELD, HELMET, RING, AMULET, CURRENCY }
enum Rarity { COMMON, UNCOMMON, RARE, LEGENDARY }
enum EquipmentType { WEAPON, BODY_ARMOR, SHIELD, HELMET, RING, AMULET, GLOVES } # TODO: Add Boots, Potions
enum Buildings { TAVERN, FORGE, ALCHEMIST, HUNTERS, HALL }


# TODO: ADD A UNIQUE CATEGORY THAT CAN'T BE MODIFIED?
const RARITY_COLORS : Dictionary = {
	Rarity.COMMON : Color.WHITE,
	Rarity.UNCOMMON : Color.CORNFLOWER_BLUE,
	Rarity.RARE : Color.GOLD,
	Rarity.LEGENDARY : Color.FUCHSIA
} 

const DEFAULT_TRAVEL_SPEED : float = 2.0
const DEFAULT_QUEST_SPEED : float = 20.0


const BUILDING_ENUM_STRING : Dictionary[Buildings, String] = {
	Buildings.TAVERN : "tavern",
	Buildings.FORGE : "forge",
	Buildings.ALCHEMIST : "alchemist",
	Buildings.HUNTERS : "hunters",
	Buildings.HALL : "hall",
}
