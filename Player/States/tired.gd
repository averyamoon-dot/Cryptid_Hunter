extends State

@export_category("Parameters")
@export var exhausted_speed: float = 200

@export_category("References")
@export var tired_timer: Timer


func activate():
	super()
	tired_timer.start()
	
func process_frame(_delta) -> State:
	if tired_timer.is_stopped():
		return state_machine.walk_state
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * exhausted_speed
	parent.move_and_slide()
	return

func deactivate():
	super()
	tired_timer.stop()
