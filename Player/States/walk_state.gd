extends State

@export var speed: float = 300

func activate():
	super()
	if Input.is_action_pressed("sprint"):
		state_machine.change_state(state_machine.sprint_state)
	
func process_frame(_delta) -> State:
	return

func process_input(event : InputEvent) -> State:
	if event.is_action_pressed("sprint"):
		return state_machine.sprint_state
	if event.is_action_pressed("crouch"):
		return state_machine.crouch_state
	return

func process_physics(_delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * speed
	parent.move_and_slide()
	return

func deactivate():
	super()
