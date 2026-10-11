extends Area2D

@export var player: CharacterBody2D
@onready var overlapping = false
@onready var held = false;

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		overlapping = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		overlapping = false
	

func _physics_process(_delta: float) -> void:
	if overlapping:
		if Input.is_action_just_pressed("interact"):
			if held:
				print("Dropped lantern")
				held = false
			else:
				print("Picked up lantern")
				held = true
	if held:
		position = player.position
