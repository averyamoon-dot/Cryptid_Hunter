extends State

@export var speed: float = 100
@export var player_tracking_timer: Timer

func activate():
	super()
	print("Enter search")
	player_tracking_timer.start()
	parent.clear_path()
	parent.set_path(parent.last_known_player_position)
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	if parent.can_see_player:
		return state_machine.chase_state
	
	if parent.path_finished():
		return state_machine.idle_state
	
	if not player_tracking_timer.is_stopped():
		parent.set_path(parent.player.global_position)
		print(player_tracking_timer.time_left)
	
	parent.velocity = parent.get_move_direction() * speed
	parent.move_and_slide()
	return

func deactivate():
	super()
