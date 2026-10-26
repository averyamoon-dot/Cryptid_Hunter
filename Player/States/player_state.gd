class_name PlayerState
extends State

@export var noise_radius: float = 0.0 # In tiles

func play_enter_sound() -> void:
	super()
	if noise_radius > 0.0:
		parent.noise_emitter.make_noise(noise_radius)

func loop_sound() -> void:
	audio_loop_timer = Timer.new()
	add_child(audio_loop_timer)
	audio_loop_timer.wait_time = while_in_state_repeat_sound_after_seconds
	audio_loop_timer.start()
	while audio_loop_timer:
		await audio_loop_timer.timeout
		if noise_radius > 0.0:
			parent.noise_emitter.make_noise(noise_radius)
			AudioController.instance.play_sound_at(while_in_state_sounds.pick_random(), parent.global_position, while_in_state_sound_low, while_in_state_sound_high)
		if audio_loop_timer:
			audio_loop_timer.start()
		
func play_exit_sound() -> void:
	if noise_radius > 0.0:
		parent.noise_emitter.make_noise(noise_radius)
