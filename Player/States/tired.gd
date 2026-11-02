extends PlayerState

@export_category("Parameters")
@export var exhausted_speed: float = 200

@export_category("References")
@export var tired_timer: Timer


func activate():
	super()
	if tired_timer.is_stopped():
		tired_timer.start()
	
func process_frame(_delta) -> State:
	if tired_timer.is_stopped():
		return state_machine.walk_state
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	print(tired_timer.time_left)
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * exhausted_speed
	
	if parent.velocity == Vector2.ZERO: 
		return state_machine.idle_tired_state
	
	parent.move_and_slide()
	return

func deactivate():
	super()
