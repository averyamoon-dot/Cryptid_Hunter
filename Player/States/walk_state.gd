extends PlayerState

@export var speed: float = 300

func activate():
	super()
	if Input.is_action_pressed("sprint"):
		if parent.remaining_sprint_time >= parent.min_sprint_threshold:
			state_machine.change_state(state_machine.sprint_state)
	
func process_frame(_delta) -> State:
	return

func process_input(event : InputEvent) -> State:
	if event.is_action_pressed("sprint"):
		if parent.remaining_sprint_time >= parent.min_sprint_threshold:
			return state_machine.sprint_state
	if event.is_action_pressed("crouch"):
		return state_machine.crouch_state
	if event.is_action_pressed("interact"):
		if parent.hiding_spot != null:
			return state_machine.hiding_state

	return

func process_physics(delta) -> State:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	parent.velocity = input_direction * speed
	
	if parent.remaining_sprint_time < parent.max_sprint_duration:
		parent.remaining_sprint_time += delta * parent.sprint_recharge_rate
		parent.remaining_sprint_time = min(parent.remaining_sprint_time, parent.max_sprint_duration)
	
	if parent.velocity == Vector2.ZERO: 
		return state_machine.idle_state
	
	parent.move_and_slide()
	
	return

func deactivate():
	super()
