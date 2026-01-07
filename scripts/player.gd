extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_shooting = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim_sprite.offset.y = -10
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip Sprite based on direction facing
	#direction == 1,0,-1 (0 for not moving)
	if direction > 0:
		anim_sprite.flip_h = false
	elif direction < 0:
		anim_sprite.flip_h = true
		
	
	#Play Animation
	if is_on_floor():
		anim_sprite.offset.y = 0
		
		if direction == 0 :
			anim_sprite.play("idle")
		elif direction != 0 and is_on_floor():
			if is_shooting:
				shoot()
			else:
			#anim_sprite.play("start_run")
				anim_sprite.play("run")
	else:
		anim_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func shoot():
	is_shooting = true
	
	#Get current frame before switching
	var saved_frame = anim_sprite.frame
	var saved_progress = anim_sprite.frame_progress
	
	#Switch animation
	if anim_sprite.animation == "run":
		#anim_sprite.offset.x = -5
		anim_sprite.play("gun_run")
		anim_sprite.frame = saved_frame
		anim_sprite.frame_progress = saved_progress
	
	#Fire bullet here
	
	
	await get_tree().create_timer(0.2).timeout
	saved_frame = anim_sprite.frame
	saved_progress = anim_sprite.frame_progress
	is_shooting = false
	#anim_sprite.offset.x = 0
