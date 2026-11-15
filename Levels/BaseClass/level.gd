class_name Level
extends Node

@export var player: Player
@export var jumpscare: Node2D
#@export var game_over: Control
@export var game_over: PackedScene
@export var animation_player: AnimationPlayer

#@export var music: AudioStream

func _ready():
	player.player_died.connect(on_player_death)
	animation_player.play("fade_in")
	#AudioController.play_music(music)
	
func on_player_death() -> void:
	#AudioController.stop_music()
	jumpscare.set_jumpscare_camera()
	jumpscare.play_animation()
	await get_tree().create_timer(2).timeout
	get_tree().call_deferred("change_scene_to_packed", game_over)
	#if game_over:
	#	game_over.visible = true
	#else:
	#	get_tree().call_deferred("reload_current_scene")
