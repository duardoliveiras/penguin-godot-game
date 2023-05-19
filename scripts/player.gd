extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jump := false

@onready var animation := $animation as AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jump = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_y == 1:
		if direction_x != 0:
			velocity.x = direction_x * SPEED
			animation.scale.x = direction_x
			animation.play("slide")
		else:
			animation.play("down")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if direction_x != 0:
			velocity.x = direction_x * SPEED
			animation.scale.x = direction_x
			if !is_jump:
				animation.play("run")
		elif is_jump:
			animation.play("jump")
			velocity.x = move_toward(velocity.x, 0, SPEED)

		else:
			animation.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()
