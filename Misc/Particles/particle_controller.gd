class_name ParticleController
extends RefCounted
	
static func spawn_particle(source: Node, scene: PackedScene, parent_to_source: bool = false) -> void:
	if not scene or not is_instance_valid(source):
		return
	
	var particle: Particle = scene.instantiate()
	if particle == null:
		return
 
	var parent: Node = source if parent_to_source else source.get_tree().current_scene
	parent.add_child(particle)
	particle.global_position = source.global_position
	particle.play()
