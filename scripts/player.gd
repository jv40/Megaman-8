extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D

const SPEED = 300.0
const SLIDE_SPEED = 500.0
const JUMP_VELOCITY = -400.0
var is_shooting = false
var is_sliding = false
var current_direction = 1;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim_sprite.offset.y = -10
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump") and not is_on_floor():
		velocity.y = -20
		velocity += get_gravity() * delta
		
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip Sprite based on direction facing
	#direction == 1,0,-1 (0 for not moving)
	if direction > 0:
		anim_sprite.flip_h = false
		current_direction = 1
	elif direction < 0:
		anim_sprite.flip_h = true
		current_direction = -1
		
	if Input.is_action_just_pressed("slide") and is_on_floor():
		slide()

	if is_sliding:
		velocity.x = current_direction * SLIDE_SPEED  # Use facing_direction
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animation(direction)

func update_animation(direction):
	var target_anim = ""
	#current_direction = direction
	
	#Play Animation
	if is_on_floor():
		anim_sprite.offset.y = 0
		
		if is_sliding:
			target_anim = "slide"
			anim_sprite.offset.x = 0
		
		elif direction == 0 :
			target_anim = "idle"
			anim_sprite.offset.x = 0
			
		else:
			if is_shooting:
				target_anim = "gun_run"
				anim_sprite.offset.x = 4 * current_direction  # Gun offset
			
			else:
				target_anim = "run"
				anim_sprite.offset.x = 0
				
	else:
		#anim_sprite.play("jump")
		target_anim = "jump"
		anim_sprite.offset.x = 0
		
	if anim_sprite.animation != target_anim:
		var saved_frame = anim_sprite.frame
		var saved_progress = anim_sprite.frame_progress
		
		anim_sprite.play(target_anim)
		
		# Preserve frame when switching between gun/normal versions
		if ("gun_" in target_anim and "gun_" not in anim_sprite.animation) or \
		("gun_" not in target_anim and "gun_" in anim_sprite.animation):
			anim_sprite.frame = saved_frame
			anim_sprite.frame_progress = saved_progress

func slide():
	is_sliding = true
	velocity.x = current_direction * SLIDE_SPEED # set velocity immediately
	await get_tree().create_timer(0.2).timeout
	is_sliding = false

func shoot():
	is_shooting = true
	await get_tree().create_timer(0.2).timeout
	is_shooting = false
