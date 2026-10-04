extends State

@export var idle_timer: Timer
@export var turn_count: int = 3
@export var max_turn_angle: float = 120.0
@export var min_turn_angle: float = 60.0
@export var angle_error: float = 2.0

#var start_angle: float
var target_angle: float
var side: float = 1.0
var turns_completed: int = 0
var finished: bool = false

func activate():
	super()
	print("Enter idle")
	parent.clear_path()
	#start_angle = parent.vision_angle
	target_angle = parent.vision_angle
	turns_completed = 0
	finished = false
	side = [-1.0, 1.0].pick_random()
	pick_target_angle()
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	
	if parent.can_see_player:
		return state_machine.chase_state
	
	if finished:
		return state_machine.wander_state
	
	# Mesures that that the cryptid turned close enough to the target angle
	var angle_diff: float = absf(angle_difference(parent.vision_angle, target_angle))
	if angle_diff < deg_to_rad(angle_error) and idle_timer.is_stopped():
		idle_timer.start()
	
	return

func deactivate():
	super()
	idle_timer.stop()

func pick_target_angle() -> void:
	var random_angle: float = deg_to_rad(randf_range(min_turn_angle, max_turn_angle))
	#target_angle = start_angle + side * random_angle
	target_angle += side * random_angle
	side = -side
	parent.facing = Vector2.from_angle(target_angle)

func _on_idle_timer_timeout():
	print(turns_completed)
	turns_completed += 1
	if turns_completed >= turn_count:
		finished = true
	else: 
		pick_target_angle()
