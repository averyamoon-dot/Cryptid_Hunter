class_name Level
extends Node

@export var player: Player
@export var jumpscare: Node2D
@export var game_over: Control
@export var music: AudioStream

func _ready():
	player.player_died.connect(on_player_death)
	AudioController.instance.play_music(music)
	
func on_player_death() -> void:
	AudioController.instance.stop_music()
	jumpscare.set_jumpscare_camera()
	jumpscare.play_animation()
	await get_tree().create_timer(2).timeout
	game_over.visible = true
