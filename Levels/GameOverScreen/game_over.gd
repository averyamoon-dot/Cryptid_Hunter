extends Control

@export var main_menu: PackedScene

func _on_retry_button_pressed():
	get_tree().call_deferred("reload_current_scene")

func _on_main_menu_button_pressed():
	get_tree().call_deferred("change_scene_to_packed", main_menu)
