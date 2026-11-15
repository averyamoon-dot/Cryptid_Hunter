extends Node2D

@export var cameraSpeed: float = 200.0

@onready var camera: Camera2D = $Camera2D

@onready var photoMode = true

func _physics_process(delta: float) -> void:
	if photoMode:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		camera.position += input_direction * cameraSpeed * delta

func takePhoto():
	pass
