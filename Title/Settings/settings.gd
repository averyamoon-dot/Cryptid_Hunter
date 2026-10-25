extends Control
@export var animation_player: AnimationPlayer
@export var master_volume_slider: HSlider
@export var music_volume_slider: HSlider
@export var sound_volume_slider: HSlider

var settings : Dictionary

func _ready() -> void:
	settings = SettingsSaveLoadManager.load_settings()
	var master_volume = settings["master_volume"]
	var music_volume = settings["music_volume"]
	var sound_volume = settings["sound_volume"]
	AudioServer.set_bus_volume_linear(0,master_volume / 100.0)
	AudioServer.set_bus_volume_linear(1,music_volume / 100.0)
	AudioServer.set_bus_volume_linear(2,sound_volume / 100.0)
	master_volume_slider.value = master_volume
	music_volume_slider.value = music_volume
	sound_volume_slider.value = sound_volume
	
func _on_back_pressed() -> void:
	settings["master_volume"] = master_volume_slider.value 
	settings["music_volume"] = music_volume_slider.value
	settings["sound_volume"] = sound_volume_slider.value
	SettingsSaveLoadManager.save_settings(settings)
	animation_player.play("exit")
func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0,value/100)
func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1,value/100)
func _on_sound_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2,value/100)
