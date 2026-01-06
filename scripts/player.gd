extends CharacterBody2D
@onready var anim_sprite = $AnimatedSprite2D

func _ready() -> void:
	setup_animations()

func setup_animations():
	#Create new SpriteFrames if necessary
	var sprite_frames = anim_sprite.sprite_frames
	if sprite_frames == null:
		sprite_frames = SpriteFrames.new()
		anim_sprite.sprite_frames = sprite_frames

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
