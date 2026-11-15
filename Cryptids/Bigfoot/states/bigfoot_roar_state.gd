extends CryptidState

@export var roar_timer: Timer
@export var roar_sound: AudioStream

var done_roaring: bool = false

func activate():
	super()
	print("Enter roar")
	roar_timer.start()
	SignalController.bigfoot_roar.emit(parent.global_position)
	AudioController.play_sound_at(roar_sound, parent.global_position)
	
func process_frame(_delta) -> State:
	return

func process_input(_event : InputEvent) -> State:
	return

func process_physics(_delta) -> State:
	if done_roaring:
		return state_machine.chase_state
	
	return

func deactivate():
	super()
	done_roaring = false


func _on_roar_timer_timeout() -> void:
	done_roaring = true
	parent.roar_available = false 
