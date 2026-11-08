extends Node

@export var animation_player: AnimationPlayer
@export var camera: Camera2D
@export var sprite: AnimatedSprite2D
@export var jumpscare_sound: AudioStream

func _ready():
	pass
	
func play_animation() -> void:
	sprite.play("jumpscare")
	AudioController.play_sound(jumpscare_sound, 0.8, 0.8)

func set_jumpscare_camera() -> void:
	camera.make_current()
