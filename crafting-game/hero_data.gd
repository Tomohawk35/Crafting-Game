extends Resource
class_name HeroData

const HERO_NAMES : Array[String] = ["Conrad", "Ivor", "Lothar"]

@export var hero_name : String
@export var hero_title : String
@export var rarity : Constants.Rarity

@export var power : float
@export var speed : float

# TODO: Add the following
#Rarity / Quantity Multiplier - affects quest rewards
#Exp Gain Multiplier
