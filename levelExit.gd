extends Area2D

@onready var interactionArea = $CollisionShape2D
@export var player: CharacterBody2D
@onready var interactable = false
@export var goToScene: PackedScene

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interact") and interactable:
		print("start interact")
		player.is_hidden = true
		var targetSpot = global_position 
		var direction = player.global_position.direction_to(targetSpot).angle()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(player, "rotation", direction, 0.5)
		tween.tween_property(player, "scale", Vector2(0.5, 0.5), 0.5)
		await tween.finished
		player.velocity = Vector2.ZERO
		player.visible = false
		get_tree().change_scene_to_packed(goToScene)

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("can exit")
		interactable = true
		


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		print("can't exit")
		interactable = true
