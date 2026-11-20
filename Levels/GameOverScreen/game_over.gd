extends Control

@export var main_menu: PackedScene
@export var fade: AnimationPlayer

func _on_retry_button_pressed():
	fade.play("fade_out")
	await fade.animation_finished
	get_tree().call_deferred("change_scene_to_file", "res://Levels/level1/level_.tscn")

func _on_main_menu_button_pressed():
	fade.play("fade_out")
	await fade.animation_finished
	get_tree().call_deferred("change_scene_to_packed", main_menu)
