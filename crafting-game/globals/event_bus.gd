extends Node

@warning_ignore_start("unused_signal")

signal display_equipment(s: SlotData, h: HeroData)
signal tavern_clicked(d: BuildingData)
signal location_clicked(location_name: String)
signal open_select_hero_window
signal hero_selected(h: HeroData)
@warning_ignore_restore("unused_signal")
