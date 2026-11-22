extends Node2D

@export var cameraSpeed: float = 200.0
@export var player: CharacterBody2D
@export var cryptid: CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var flash = $Camera2D/cameraFlash
@export var cameraArea: Area2D

@onready var sound = $AudioStreamPlayer2D

@onready var photoTaken = false

var photoMode = false

var goodFraming = false

func _ready() -> void:
	flash.modulate.a = 0.0
	

func _physics_process(delta: float) -> void:
	if photoMode:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		camera.position += input_direction * cameraSpeed * delta
		if Input.is_action_pressed("takePhoto"):
			takePhoto()
	if player.cryptid_seen == true and cryptid.state_machine.state != cryptid.state_machine.chase_state and cryptid.state_machine.state != cryptid.state_machine.roar_state and player.state_machine.state != player.state_machine.hiding_state:
		if Input.is_action_just_pressed("open_camera"):
			if photoMode:
				exit()
			else:
				enter()

func takePhoto():
	print("takingPhoto")
	flash.modulate.a = 1.0
	sound.play()
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.5)
	await tween.finished
	if goodFraming:
		photoTaken = true
	exit()

func enter():
	print("enter photomode")
	photoMode = true
	camera.make_current()
	get_tree().paused = true
	PhysicsServer2D.set_active(true)

func exit():
	print("exit photomode")
	photoMode = false
	get_tree().paused = false
	player.camera.make_current()

func _on_bigfoot_area_area_entered(area: Area2D) -> void:
	if area == cameraArea:
		print("Good Framing")
		goodFraming = true


func _on_bigfoot_area_area_exited(area: Area2D) -> void:
	if area == cameraArea:
		print("Bad Framing")
		goodFraming = false
