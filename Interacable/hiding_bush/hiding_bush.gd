extends Area2D
@onready var overlapping = false
@export var player: CharacterBody2D
@onready var hiding = false
@export var interact: AudioStream


func _ready():
	HideableObjects.hideableObjects.append(self)


func _input(event: InputEvent) -> void:
	if overlapping and event.is_action_pressed("interact"):
		AudioController.instance.play_sound(interact, 0.7, 1.3)
		if hiding:
			player.position = position
			player.visible = true;
			hiding = false
		else:
			player.visible = false;
			


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		overlapping = true



func _on_body_exited(body: Node2D) -> void:
	if body == player:
		overlapping = false
