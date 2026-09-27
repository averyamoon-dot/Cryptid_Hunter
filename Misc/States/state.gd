class_name State
extends Node

@export_color_no_alpha var placeholder_state_color : Color = Color.WHITE
@export var animation_name : String

var parent : Node2D
var sprite : AnimatedSprite2D
var state_machine : StateMachine

func activate():
	pass


@warning_ignore("unused_parameter")
func process_frame(delta) -> State:
	return null
@warning_ignore("unused_parameter")
func process_physics(delta) -> State:
	return null
@warning_ignore("unused_parameter")
func process_input(event : InputEvent) -> State:
	return null

func deactivate():
	pass
