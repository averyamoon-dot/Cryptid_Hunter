extends State

@export var crouch_speed: float = 150

var is_crouching: bool = false

func activate():
	super()
	is_crouching = true
	
func process_frame(_delta) -> State:
	return

func process_input(event : InputEvent) -> State:
	if event.is_action_released("crouch"):
		return state_machine.walk_state
	if event.is_action_pressed("sprint"):
		return state_machine.sprint_state
	return

func process_physics(delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * crouch_speed
	parent.move_and_slide()
	if parent.remaining_sprint_time < parent.max_sprint_duration:
		parent.remaining_sprint_time += delta * parent.sprint_recharge_rate
		parent.remaining_sprint_time = min(parent.remaining_sprint_time, parent.max_sprint_duration)
	return

func deactivate():
	super()
	is_crouching = false
