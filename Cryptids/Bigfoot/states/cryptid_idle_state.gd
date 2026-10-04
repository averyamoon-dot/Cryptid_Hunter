extends State

@export var idle_timer: Timer
@export var pause_timer: Timer
@export var look_angle: float = 90.0
@export var look_speed: float = 2.0

var start_angle: float
var target_angle: float

func activate():
	super()
	print("Enter idle")
	idle_timer.start()
	start_angle = parent.facing.angle()
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	return

func deactivate():
	super()
	idle_timer.stop()
