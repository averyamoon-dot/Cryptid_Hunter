extends CryptidState

@export var speed: float = 100

func activate():
	super()
	print("Enter chase")
	parent.clear_path()
	parent.clear_hiding_target()

func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	if parent.hiding_target == null and parent.player.is_hidden \
		and parent.can_see_player and parent.player.hiding_spot != null:
		parent.pursue_hiding_spot(parent.player.hiding_spot)

	if parent.hiding_target != null:
		if not parent.player.is_hidden:
			parent.clear_hiding_target()
			return
	else:
		if not parent.can_see_player:
			return state_machine.search_state
		parent.set_path(parent.player.global_position)

	parent.velocity = parent.get_move_direction() * speed
	parent.move_and_slide()

	if parent.reached_hiding_spot():
		parent.catch_hidden_player()
	return

func deactivate():
	super()
	parent.clear_hiding_target()
