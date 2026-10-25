extends Control
@export var animation_player: AnimationPlayer

func _on_back_pressed() -> void:
	animation_player.play("exit")
