extends Node

@export var animation_player: AnimationPlayer
@export var camera: Camera2D

func _ready():
	pass
	
func play_animation() -> void:
	animation_player.play("jumpscare")

func set_jumpscare_camera() -> void:
	camera.make_current()
