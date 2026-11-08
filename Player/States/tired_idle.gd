extends PlayerState

@export_category("References")
@export var tired_timer: Timer

func activate():
	super()
	print("enter_tried")
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	print(tired_timer.time_left)
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if tired_timer.is_stopped():
		return state_machine.idle_state
	if input_direction:
		return state_machine.tired_state
		
	return

func deactivate():
	super()
	
