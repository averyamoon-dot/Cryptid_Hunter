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
@export var noise_emitter: NoiseEmitter
@export var audio_listener: AudioListener2D
@export var ambient_music_player: AudioStreamPlayer2D
@export var chase_music_player: AudioStreamPlayer2D


@export_category("Music")
@export var shoulda_coulda_wooda: AudioStreamOggVorbis
@export var shouldnt_cant_wont: AudioStreamOggVorbis


#Hiding variables
@onready var interactionArea: Area2D = $InteractionArea
var hiding_spot = null
var is_hidden = false

@onready var holding_lantern = false

var remaining_sprint_time: float
var facing: Vector2 = Vector2.RIGHT
var vision_angle: float = 0.0    

func _ready() -> void:
	remaining_sprint_time = max_sprint_duration
	vision_angle = facing.angle()
	audio_listener.make_current()
	state_machine.parent = self
	state_machine.sprite = sprite
	await get_tree().process_frame
	state_machine.initialize_state_machine()
	
func play_animation(animation_name: String, animation_speed) -> void: 
	sprite.speed_scale = animation_speed
	if animation_name:
		sprite.play(animation_name)
	else:
		sprite.play("idle")
	
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		enter_chase()
	if event.is_action_pressed("debug_2"):
		exit_chase()
func enter_chase() -> void:
	chase_music_player.stream = shouldnt_cant_wont
	if chase_music_player.volume_db < -50 or !chase_music_player.playing:
		chase_music_player.play()
		chase_music_player.volume_db = 0
		ambient_music_player.volume_db = -1
		while ambient_music_player.volume_db > -70 and ambient_music_player.volume_db <= -1:
			ambient_music_player.volume_db = move_toward(ambient_music_player.volume_db, -80.0, 1)
			await get_tree().create_timer(0.1).timeout
		ambient_music_player.volume_db = -80
	else:
		ambient_music_player.volume_db = -80
		while chase_music_player.volume_db < -10:
			chase_music_player.volume_db = move_toward(chase_music_player.volume_db, 0.0, 1)
			await get_tree().create_timer(0.1).timeout
		chase_music_player.volume_db = 0
func exit_chase() -> void:
	chase_music_player.volume_db = -1
	ambient_music_player.volume_db = -80
	while chase_music_player.volume_db > -70 and chase_music_player.volume_db <= -1:
		ambient_music_player.volume_db = move_toward(ambient_music_player.volume_db, 0.0, 2)
		chase_music_player.volume_db = move_toward(chase_music_player.volume_db, -80.0, 0.5)
		await get_tree().create_timer(0.1).timeout
	ambient_music_player.volume_db = 0
	if chase_music_player.volume_db <= -70:
		chase_music_player.stop()

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if HideableObjects.hideableObjects.has(area):
		hiding_spot = area
		area.light.visible = true

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if hiding_spot == area:
		area.light.visible = false
		hiding_spot = null
