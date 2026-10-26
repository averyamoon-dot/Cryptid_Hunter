extends "res://Title/Settings/settings.gd"
func _on_back_pressed() -> void:
	settings["master_volume"] = master_volume_slider.value 
	settings["music_volume"] = music_volume_slider.value
	settings["sound_volume"] = sound_volume_slider.value
	SettingsSaveLoadManager.save_settings(settings)
	animation_player.play("turn_page_left")
