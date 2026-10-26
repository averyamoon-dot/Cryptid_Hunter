extends Control
@export var animation_player: AnimationPlayer
@export var transition: AnimationPlayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			close_pause()
		else:
			open_pause()
func open_pause():
	get_tree().paused = true
	animation_player.play("enter")
func close_pause():
	get_tree().paused = false
	animation_player.play("exit")

func _on_resume_pressed() -> void:
	close_pause()
func _on_settings_pressed() -> void:
	animation_player.play("turn_page_right")

func _on_quit_pressed() -> void:
	if transition.is_playing():
		return
	transition.play("exit")
	await transition.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Title/title.tscn")
