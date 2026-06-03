extends RefCounted
class_name HeroFactory

static func generate_hero() -> HeroData: # TODO: Incorporate tavern level
	var h : HeroData = HeroData.new()
	h.hero_name = HeroData.HERO_NAMES.pick_random()
	h.hero_title = HeroData.HERO_TITLES.pick_random() # TODO: Change to default title for jobs
	h.hero_job = GameDB.HERO_JOBS.pick_random()
	h.level = randi_range(1, 8) # TODO: Base off of tavern level?
	h.rarity = Constants.Rarity.values()[randi_range(0, Constants.Rarity.size() - 1)] # TODO: Add weighting for rarity
	h.set_base_stats()
	h.get_initial_stats()
	h.get_total_stats()
	return h

static func calculate_recruit_cost(h: HeroData) -> int:
	return (h.rarity + 1) * h.level * 10
	# TODO: Maybe add a cost reduction into the tavern level or some town value
