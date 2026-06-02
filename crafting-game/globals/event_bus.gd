## Global - EventBus
extends Node

@warning_ignore_start("unused_signal")


signal display_equipment(s: SlotData, h: HeroData)
signal tavern_clicked

signal location_clicked(location_name: String)
signal building_clicked(building_name: String)


@warning_ignore_restore("unused_signal")
