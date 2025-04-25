extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -500.0
@export var gravity : float = 1000.0

var animated_sprite : AnimatedSprite2D
var last_direction : String = "right"

func _ready():
	animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var velocity = self.velocity

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
			animated_sprite.play("jump-%s" % last_direction)

	# Direction input
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
		last_direction = "right"
	elif Input.is_action_pressed("move_left"):
		direction -= 1
		last_direction = "left"

	velocity.x = direction * speed

	# Animation logic
	if not is_on_floor():
		animated_sprite.play("jump-%s" % last_direction)
	elif direction > 0:
		animated_sprite.play("move-right")
	elif direction < 0:
		animated_sprite.play("move-left")
	else:
		animated_sprite.play("idle-%s" % last_direction)

	# Apply movement
	self.velocity = velocity
	move_and_slide()
