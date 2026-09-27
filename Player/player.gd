class_name Player
extends CharacterBody2D

@export_category("References")
@export var state_machine : StateMachine
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	state_machine.parent = self
	state_machine.sprite = sprite
	await get_tree().process_frame
	state_machine.initialize_state_machine()
