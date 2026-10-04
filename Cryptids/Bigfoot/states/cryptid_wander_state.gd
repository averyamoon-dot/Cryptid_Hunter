extends State

@export var speed: float = 75

func activate():
	super()
	print("Enter wander")
	parent.clear_path()
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	if parent.can_see_player:
		return state_machine.chase_state
	
	if parent.path_finished():
		parent.pick_random_target()
		return
	
	parent.velocity = parent.get_move_direction() * speed
	parent.move_and_slide()
	return
	

func deactivate():
	super()
