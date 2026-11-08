extends Area2D

@export_group("Audio")
@export var step_on_sounds: Array[AudioStream]
@export var min_pitch: float = 0.7
@export var max_pitch: float = 1.3
@export_group("Parameters")
@export var noise_radius: float 
@export var object_particle: PackedScene
@export_group("References")
@export var noise_emitter: NoiseEmitter


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		noise_emitter.make_noise(noise_radius)
		ParticleController.spawn_particle(self, object_particle)
		AudioController.instance.play_sound_at(step_on_sounds.pick_random(), global_position, min_pitch, max_pitch)
		queue_free()
