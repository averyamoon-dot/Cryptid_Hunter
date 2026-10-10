class_name Player
extends CharacterBody2D

signal player_died

@export_category("Parameters")
@export var max_sprint_duration: float = 6.0
@export var min_sprint_threshold: float = 2.0
@export var sprint_recharge_rate: float = 1.0
@export var turn_speed: float = 4.0 # In radians

@export_category("References")
@export var state_machine : StateMachine
@export var sprite: AnimatedSprite2D

var remaining_sprint_time: float
var facing: Vector2 = Vector2.RIGHT
var vision_angle: float = 0.0    

func _ready() -> void:
	remaining_sprint_time = max_sprint_duration
	state_machine.parent = self
	state_machine.sprite = sprite
	await get_tree().process_frame
	state_machine.initialize_state_machine()
	
func _physics_process(delta: float) -> void:
	update_facing(delta)

func update_facing(delta: float) -> void:
	if velocity.length() > 1.0:
		facing = velocity.normalized()
	
	var target_angle: float = facing.angle()
	var diff: float = angle_difference(vision_angle, target_angle)
	var max_step: float = turn_speed * delta
	vision_angle += clampf(diff, -max_step, max_step)
	
	rotation = vision_angle

func die():
	player_died.emit()
