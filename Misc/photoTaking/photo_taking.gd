extends Node2D

@export var cameraSpeed: float = 200.0

@onready var camera: Camera2D = $Camera2D
@onready var flash = $Camera2D/cameraFlash
@onready var cameraArea = $Camera2D/cameraArea
@onready var bigFootArea = $BigFoot/Area2D

@export var photoTaken = false

var photoMode = true

var goodFraming = false

func _ready() -> void:
	flash.modulate.a = 0.0
	
func _physics_process(delta: float) -> void:
	if photoMode:
		get_tree().paused = true
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		camera.position += input_direction * cameraSpeed * delta
		if Input.is_action_pressed("takePhoto"):
			takePhoto()
		if Input.is_action_pressed("pause"):
			exit()

func takePhoto():
	print("takingPhoto")
	flash.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.5)
	await tween.finished
	if goodFraming:
		photoTaken = true
	exit()

func exit():
	photoMode = false
	get_tree().paused = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == bigFootArea:
		goodFraming = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == bigFootArea:
		goodFraming = false
