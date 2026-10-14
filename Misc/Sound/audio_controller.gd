class_name AudioController
extends Node2D  

## Using AudioController.instance, any script can reach the audio controller
## as long as the AudioController node is within the same scene
static var instance: AudioController

func _ready() -> void:
	instance = self

## Reset instance on exiting scene tree
func _exit_tree() -> void:
	if instance == self:
		instance = null

# Non positional
func play_sound(sfx : AudioStream, min_pitch : float = 0.7, max_pitch : float = 1.3):
	var sfx_player
	if not sfx:
		return
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.bus = "SFX"
	sfx_player.stream = sfx
	sfx_player.pitch_scale = randf_range(min_pitch,max_pitch)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()

# Positional sound
func play_sound_at(sfx : AudioStream, world_position : Vector2, min_pitch : float = 0.7, max_pitch : float = 1.3):
	if not sfx:
		return
	var sfx_player := AudioStreamPlayer2D.new()
	add_child(sfx_player)
	sfx_player.global_position = world_position
	sfx_player.bus = "SFX"
	sfx_player.stream = sfx
	sfx_player.pitch_scale = randf_range(min_pitch, max_pitch)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()

func change_master_volume_to(value: float):
	AudioServer.set_bus_volume_linear(0,value)
func change_music_volume_to(value: float):
	AudioServer.set_bus_volume_linear(1,value)
func change_sfx_volume_to(value: float):
	AudioServer.set_bus_volume_linear(2,value)
