extends PlayerState

@export var looking_timer: Timer

var roar_timer: float = 0.0
var direction_to_bigfoot: Vector2

func activate() -> void:
	super()
	looking_timer.start()
	parent.velocity = Vector2.ZERO 

func process_physics(delta: float) -> State:
	direction_to_bigfoot = (parent.roar_position - parent.global_position).normalized()
	parent.facing = direction_to_bigfoot
	
	parent.update_facing(delta)
	parent.move_and_slide()
	
	if looking_timer.is_stopped():
		return state_machine.idle_state
		
	return
