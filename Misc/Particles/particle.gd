class_name Particle
extends CPUParticles2D

@export var spawn_offset : Vector2

func play() -> void:
	position += spawn_offset
	emitting = true
	one_shot = true
	for particle in get_children():
		if particle.is_class("CPUParticles2D"):
			particle.emitting = true
			particle.one_shot = true
	await finished
	visible = false
	queue_free()
