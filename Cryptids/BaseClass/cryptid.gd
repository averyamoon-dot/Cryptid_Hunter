class_name Cryptid
extends CharacterBody2D

@export_category("Parameters")
@export_group("Navigation")
@export var start_distance: float = 20 # Distance in tiles
@export var min_radius: int = 1 # In tiles
@export var max_radius: int = 6 # In tiles
@export_group("Vision")
@export var turn_speed_angry: float = 6.0 # In radians 
@export var turn_speed_passive: float = 4.0 # In radians
@export var sight_grace: float = 0.3    
@export_group("Hearing")
@export var hearing_multiplier: float = 1.0
@export var muffle_per_wall: float = 0.5 # Percentage

@export_category("References")
@export var player: Player
@export var floor_layer: TileMapLayer
@export var wall_layer: TileMapLayer
@export var state_machine : StateMachine
@export var sprite: AnimatedSprite2D
@export var vision_cone: Area2D
@export var ray_cast: RayCast2D
@export var collision: CollisionShape2D
@export var killzone: Area2D


var pathfinder: PathFinder
var path: PackedVector2Array = PackedVector2Array()
var path_index: int = 0
var starting_position: Vector2

var path_line: Line2D = Line2D.new()
var facing: Vector2 = Vector2.RIGHT
var last_known_player_position: Vector2
var can_see_player: bool = false
var heard_noise: bool = false

var vision_angle: float = 0.0            
var sight_extension: float = 0.0

func _ready() -> void:
	killzone.body_entered.connect(_on_killzone_body_entered)
	SignalController.noise_made.connect(on_noise_heard)
	
	pathfinder = PathFinder.new()
	pathfinder.setup(floor_layer, wall_layer)
	
	path_line.top_level = true
	path_line.width = 4
	path_line.default_color = Color.RED
	add_child(path_line)
	
	vision_angle = facing.angle()
	
	starting_position = global_position
	
	state_machine.parent = self
	state_machine.sprite = sprite
	await get_tree().process_frame
	state_machine.initialize_state_machine()

func _physics_process(delta: float) -> void:
	update_vision(delta)
	update_facing(delta)
	
func _process(_delta: float) -> void:
	# Setting debug line path
	var points: PackedVector2Array = PackedVector2Array()
	if not path_finished():
		points.append(global_position)
		points.append_array(path.slice(path_index))
	path_line.points = points

func set_path(target: Vector2) -> void:
	path = pathfinder.get_global_path(global_position, target)
	path_index = 1

func pick_random_target() -> void:
	if pathfinder.check_distance(global_position, starting_position, start_distance):
		set_path(pathfinder.random_point_near(global_position, min_radius, max_radius))
	else:
		set_path(starting_position)
	
func clear_path() -> void:
	path = PackedVector2Array()
	path_index = 0
 
func path_finished() -> bool:
	return path_index >= path.size()

func get_move_direction() -> Vector2:
	while not path_finished() and passed_point(path_index):
		path_index += 1

	if path_finished():
		return Vector2.ZERO

	facing = global_position.direction_to(path[path_index])
	return facing

func passed_point(index: int) -> bool:
	var part = path[index] - path[index - 1]
	return (global_position - path[index]).dot(part) >= 0.0
	
func get_player_position() -> Vector2:
	return player.global_position

func update_vision(delta: float) -> void:
	var seen: bool = false
	
	if vision_cone.overlaps_body(player) and !player.is_hidden:
		ray_cast.target_position = ray_cast.to_local(player.global_position)
		ray_cast.force_raycast_update()
		if ray_cast.get_collider() == player:
			seen = true
			last_known_player_position = player.global_position

	if seen:
		sight_extension = sight_grace
	else:
		sight_extension -= delta
	can_see_player = sight_extension > 0.0

func update_facing(delta: float) -> void:
	var target_angle: float 
	var turn_speed: float

	#if can_see_player:
		#target_angle = global_position.direction_to(last_known_player_position).angle()
		#turn_speed = turn_speed_angry
	#else:
	target_angle = facing.angle()
	turn_speed = turn_speed_passive

	var diff: float = angle_difference(vision_angle, target_angle)
	var max_step: float = turn_speed * delta
	vision_angle += clampf(diff, -max_step, max_step)
	
	self.rotation = vision_angle
	
func play_animation(animation_name: String, animation_speed) -> void: 
	sprite.speed_scale = animation_speed
	if animation_name:
		sprite.play(animation_name)
	else:
		sprite.play("idle")
	
func _on_killzone_body_entered(body: Node2D) -> void:
	if body is Player and !player.is_hidden:
		body.die()
		
func on_noise_heard(pos: Vector2, radius: float, source: Node) -> void:
	if source == self or can_see_player: 
		return
	
	var max_distance: float = radius * hearing_multiplier
	if not pathfinder.check_distance(global_position, pos, max_distance):
		return  
	
	# Wall check
	# Each wall reduces noise range
	var walls: int = pathfinder.count_walls_between(global_position, pos)
	var muffled_range: float = max_distance / (1.0 + muffle_per_wall * walls)
	if pathfinder.check_distance(global_position, pos, muffled_range):
		last_known_player_position = pos
		heard_noise = true
