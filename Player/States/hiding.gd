extends PlayerState

func activate():
	super()
	await enterBush()
	parent.is_hidden = true

func enterBush():
	var targetSpot = parent.hiding_spot.global_position 
	var direction = parent.global_position.direction_to(targetSpot).angle()
	var tween = create_tween()
	tween.tween_property(parent, "rotation", direction, 0.5)
	tween.tween_property(parent, "scale", Vector2(0.5, 0.5), 0.5)
	await tween.finished
	parent.velocity = Vector2.ZERO
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
	parent.is_hidden = false
	var tween = create_tween()
	tween.tween_property(parent, "scale", Vector2(1, 1), 0.5)
	await tween.finished
	parent.velocity = Vector2.ZERO
	parent.visible = true
