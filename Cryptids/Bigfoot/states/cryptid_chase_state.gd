extends State

@export var speed: float = 100

func activate():
	super()
	print("Enter chase")
	parent.clear_path()
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	if not parent.can_see_player:
		return state_machine.search_state
	
	parent.set_path(parent.player.global_position)
	parent.velocity = parent.get_move_direction() * speed
	parent.move_and_slide()
	return

func deactivate():
	super()
