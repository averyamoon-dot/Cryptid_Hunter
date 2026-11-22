extends Node

@export var pitfall_sound: AudioStream

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
