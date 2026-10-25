extends PlayerState

func activate():
	super()
	parent.visible = false
	
func process_frame(_delta) -> State:
	return


func process_input(event : InputEvent) -> State:
	if event.is_action_pressed("interact"):
		return state_machine.idle_state
	return


func process_physics(_delta) -> State:
	parent.velocity = Vector2(0,0)
	parent.move_and_slide()
	return


func deactivate():
	super()
	parent.visible = true
