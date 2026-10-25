extends Control
@export var settings: Control
@export var credits: Control
@export var title_animations: AnimationPlayer
@export var transition: AnimationPlayer

func _on_play_button_pressed() -> void:
	if transition.is_playing():
		return
	transition.play("exit")
	await transition.animation_finished
	get_tree().change_scene_to_file("res://Levels/test_level/main.tscn")
func _on_settings_button_pressed() -> void:
	settings.animation_player.play("enter")
func _on_credits_button_pressed() -> void:
	credits.animation_player.play("enter")
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and title_animations.current_animation != "title_loop":
		title_animations.play("title_loop")
func _on_quit_button_pressed() -> void:
	if transition.is_playing():
		return
	transition.play("exit")
	await transition.animation_finished
	get_tree().quit()
