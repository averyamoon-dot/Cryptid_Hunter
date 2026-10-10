class_name Level
extends Node

@export var player: Player
@export var jumpscare: Node2D

func _ready():
	player.player_died.connect(on_player_death)
	
func on_player_death() -> void:
	jumpscare.set_jumpscare_camera()
	jumpscare.play_animation()
	await jumpscare.animation_player.animation_finished
	get_tree().call_deferred("reload_current_scene")
