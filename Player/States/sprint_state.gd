extends State

@export_category("Parameters")
@export var sprint_speed: float = 500

@export_category("References")
@export var sprint_timer: Timer

var is_sprinting: bool = false

func activate():
	super()
	is_sprinting = true
	sprint_timer.start()
	
func process_frame(_delta) -> State:
	if sprint_timer.is_stopped():
		return state_machine.tired_state
	return

func process_input(event : InputEvent) -> State:
	if event.is_action_released("sprint"):
		return state_machine.walk_state
	return

func process_physics(_delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * sprint_speed
	parent.move_and_slide()
	return

func deactivate():
	super()
	is_sprinting = false
	sprint_timer.stop()
