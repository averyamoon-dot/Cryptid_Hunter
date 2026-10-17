class_name PlayerState
extends State

@export var noise_radius: float = 0.0

func play_enter_sound() -> void:
	super()
	if noise_radius > 0.0:
		parent.noise_emitter.make_noise(noise_radius)

func loop_sound() -> void:
	super()
	if noise_radius > 0.0:
		parent.noise_emitter.make_noise(noise_radius)
		
func play_exit_sound() -> void:
	if noise_radius > 0.0:
		parent.noise_emitter.make_noise(noise_radius)
