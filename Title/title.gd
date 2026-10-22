extends Control
@export var settings: Control


func _on_settings_button_pressed() -> void:
	settings.animation_player.play("enter")
