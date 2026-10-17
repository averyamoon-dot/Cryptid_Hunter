class_name NoiseEmitter
extends Node2D

signal noise_emitted

@export var repeat_timer: Timer

var repeat_radius: float = 0.0

func _ready() -> void:
	repeat_timer.one_shot = false
	repeat_timer.timeout.connect(_on_repeat_timer_timeout)

func make_noise(radius: float = 0.0) -> void:
	SignalController.noise_made.emit(global_position, radius, get_parent())
	noise_emitted.emit()
	
func start_repeating(radius: float, duration: float) -> void:
	repeat_radius = radius
	make_noise(repeat_radius)
	repeat_timer.start(duration)
 
func stop_repeating() -> void:
	repeat_timer.stop()
 
func _on_repeat_timer_timeout() -> void:
	make_noise(repeat_radius)
