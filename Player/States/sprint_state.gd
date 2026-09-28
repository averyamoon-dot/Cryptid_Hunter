extends State

@export var sprint_speed: float = 450

var is_sprinting: bool = false

func activate():
	super()
	is_sprinting = true
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * sprint_speed
	parent.move_and_slide()
	if not Input.is_action_pressed("sprint"):
		return state_machine.walk_state
	return

func deactivate():
	super()
	is_sprinting = false
