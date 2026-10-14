extends CharacterBody2D


const SPEED = 130
const JUMP_VELOCITY = -300
const ROLL_VELOCITY = 250
var roll = false
var roll_sound_played = false
var coyote = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var roll_timer: Timer = $RollTimer
@onready var roll_sound: AudioStreamPlayer2D = $RollSound
@export var dead: bool
@export var invincible = false

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote += 1
	else:
		coyote = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote <= 5):
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip player sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Handle Roll
	if Input.is_action_just_pressed("down"):
		roll = true
		invincible = true
		roll_timer.start()
		
	# Play animations
	if not dead:
		if roll:
			animated_sprite.play("roll")
			if not roll_sound_played:
				roll_sound.play()
				roll_sound_played = true
		else:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
	else:
		animated_sprite.play("death")
	
	# Handle the movement/deceleration.
	if roll:
		velocity.x = direction*ROLL_VELOCITY
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Handle Roll Timing
func _on_timer_timeout() -> void:
	roll = false
	invincible = false
	roll_sound_played = false
