extends Area2D

@onready var timer: Timer = $Timer
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@export var instakill = false

func _on_body_entered(body: Node2D) -> void:
	if (not body.invincible) or instakill:
		print("You Died!")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		body.dead = true
		death_sound.play()
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
