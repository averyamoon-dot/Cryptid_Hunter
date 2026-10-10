class_name Level
extends Node

@export var player: Player

func _ready():
	player.player_died.connect(on_player_death)
	
func on_player_death() -> void:
	get_tree().reload_current_scene()
