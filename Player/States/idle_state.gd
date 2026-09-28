extends State

func activate():
	super()
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction:
		return state_machine.walk_state
	parent.move_and_slide()
	if parent.remaining_sprint_time < parent.max_sprint_duration:
		parent.remaining_sprint_time += delta * parent.sprint_recharge_rate
		parent.remaining_sprint_time = min(parent.remaining_sprint_time, parent.max_sprint_duration)
	return

func deactivate():
	super()
