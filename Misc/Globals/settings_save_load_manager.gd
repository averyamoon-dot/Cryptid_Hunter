extends Node

var SETTINGS_SAVE_PATH = "user://settings.save"

var settings : Dictionary = {
	"master_volume" : 75,
	"music_volume" : 75,
	"sound_volume" : 75,
	"fullscreen" : false,
}

func load_settings() -> Dictionary:
	if FileAccess.file_exists(SETTINGS_SAVE_PATH):
		var file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		settings = data.duplicate()
	return settings.duplicate()
func save_settings(settings_to_save : Dictionary):
	settings = settings_to_save.duplicate()
	var file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.WRITE)
	file.store_var(settings.duplicate())
	file.close()
func reset_settings():
	var file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.WRITE)
	file.store_var(settings.duplicate())
	file.close()
