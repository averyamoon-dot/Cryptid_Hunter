extends Node2D
@onready var on = true
@onready var flashlight = $PointLight2D

func _physics_process(_delta: float) -> void:
	if on:
		flashlight.visible = true
		if Input.is_action_just_pressed("toggle_flashlight"):
			on = false
	else:
		flashlight.visible = false
		if Input.is_action_just_pressed("toggle_flashlight"):
			on = true
