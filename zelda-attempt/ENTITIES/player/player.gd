extends CharacterBody3D


# jump settings
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# movement speeds
@export var base_speed := 6.0
@export var run_speed := 25.0
@onready var camera_3d: Node3D = $"CAMERA CONTROLLER"

# movement direction input
var movement_input := Vector2.ZERO



func jump_logic(delta) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity

	# apply gravity
	var gravity = jump_gravity if velocity.y > 0 else fall_gravity
	velocity.y -= gravity * delta
	


func _physics_process(delta: float) -> void:
	# read input relative to camera
	# old move code
	# movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera_3d.global_rotation.y)
	
	#velocity = Vector3(movement_input.x,0,movement_input.y) * base_speed
	
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()

	

	

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera_3d.global_rotation.y)
	
	# convert horizontal velocity to 2d
	var vel_2d = Vector2(velocity.x, velocity.z)
	#print("move_logic running")
	

	var is_running: bool = Input.is_action_pressed("run")
	#print(is_running)
	

	if movement_input != Vector2.ZERO:
		# choose speed depending on run key
		var speed = run_speed if is_running else base_speed
		#print(speed)

		# run anim
		$godetteSkin/AnimationPlayer.current_animation = 'Running_B'
		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)

		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		var target_angle = movement_input.angle()
		$godetteSkin.rotation.y = target_angle
	else:
		# slow down when no input
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		# walk anim
		$godetteSkin/AnimationPlayer.current_animation = 'Idle'
