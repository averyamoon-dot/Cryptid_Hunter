class_name State
extends Node

@export_color_no_alpha var placeholder_state_color : Color = Color.WHITE
@export var animation_name : String
@export var animation_speed: float = 1.0

@export_category("Audio")
@export_group("Enter sound","enter_sound_")
@export var enter_sound_sounds : Array[AudioStream]
@export var enter_sound_pitch_low : float = 0.7
@export var enter_sound_pitch_high : float = 1.3
@export_group("While in state sound","while_in_state_")
@export var while_in_state_sounds : Array[AudioStream]
@export var while_in_state_sound_low : float = 0.7
@export var while_in_state_sound_high : float = 1.3
@export var while_in_state_repeat_sound_after_seconds: float = 0.1
@export_group("Exit Sound","exit_sound_")
@export var exit_sound_sounds : Array[AudioStream]
@export var exit_sound_pitch_low : float = 0.7
@export var exit_sound_pitch_high : float = 1.3

var parent: Node2D
var sprite: AnimatedSprite2D
var state_machine: StateMachine
var audio_loop_timer: Timer

func activate():
	sprite.self_modulate = placeholder_state_color
	parent.play_animation(animation_name, animation_speed)
	
	if enter_sound_sounds:
		play_enter_sound()
	if while_in_state_sounds:
		loop_sound()

@warning_ignore("unused_parameter")
func process_frame(delta) -> State:
	return null
@warning_ignore("unused_parameter")
func process_physics(delta) -> State:
	return null
@warning_ignore("unused_parameter")
func process_input(event : InputEvent) -> State:
	return null

func deactivate():
	if audio_loop_timer:
		audio_loop_timer.queue_free()
	if exit_sound_sounds:
		play_exit_sound()
		
func play_enter_sound() -> void:
	AudioController.instance.play_sound_at(enter_sound_sounds.pick_random(), parent.global_position, enter_sound_pitch_low, enter_sound_pitch_high)

func loop_sound() -> void:
	audio_loop_timer = Timer.new()
	add_child(audio_loop_timer)
	audio_loop_timer.wait_time = while_in_state_repeat_sound_after_seconds
	audio_loop_timer.start()
	while audio_loop_timer:
		await audio_loop_timer.timeout
		AudioController.instance.play_sound_at(while_in_state_sounds.pick_random(), parent.global_position, while_in_state_sound_low, while_in_state_sound_high)
		if audio_loop_timer:
			audio_loop_timer.start()
	
func play_exit_sound() -> void: 
	AudioController.instance.play_sound_at(exit_sound_sounds.pick_random(), parent.global_position, exit_sound_pitch_low, exit_sound_pitch_high)
