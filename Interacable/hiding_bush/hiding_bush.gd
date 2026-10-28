extends Area2D
@onready var overlapping = false
@export var player: CharacterBody2D
@onready var hiding = false
@export var interact: AudioStream
@onready var animation_player = $AnimationPlayer
@onready var light = $PointLight2D
@onready var playerInside = false




func _ready():
	HideableObjects.hideableObjects.append(self)
	light.visible = false


func player_entering() -> void:
	playerInside = true
	animation_player.play("enter")
	await animation_player.animation_finished
	animation_player.play("hiding")

func player_exiting() -> void:
	playerInside = false
	animation_player.play("enter")
	await animation_player.animation_finished
	animation_player.stop()
