class_name Player
extends CharacterBody2D

@export_category("Parameters")
@export var max_sprint_duration: float = 6.0
@export var min_sprint_threshold: float = 2.0
@export var sprint_recharge_rate: float = 1.0


var remaining_sprint_time: float

@export_category("References")
@export var state_machine : StateMachine
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	remaining_sprint_time = max_sprint_duration
	state_machine.parent = self
	state_machine.sprite = sprite
	await get_tree().process_frame
	state_machine.initialize_state_machine()
