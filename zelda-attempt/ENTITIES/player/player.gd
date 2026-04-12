#player.gd
extends CharacterBody3D
@onready var skin = $godetteSkin
# jump settings
@export var jump_height : float = 10.1
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3
#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
#@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
# movement speeds
@export var base_speed := 6.0
@export var run_speed := 25.0
@onready var camera_3d: Node3D = $"CAMERA CONTROLLER"
@onready var ui = $UI
@onready var run_particles = $RunParticles

@export var defend_speed := 2.0
var jump_velocity : float = 0.0
var jump_gravity : float = 0.0
var fall_gravity : float = 0.0
enum  spells {FIREBALL, HEAL}
var current_spell = spells.FIREBALL
var health = 5:
	set(value):
		ui.update_health(value, value - health)
		health = value
		if health <= 0:
			get_tree().quit()
var energy = 100:
	set(value):
		energy = min(100,value)	
		ui.update_energy(energy)
		
var stamina = 100:
	set(value):
		ui.update_stamina(stamina,value)
		if stamina == 100 and value < 100:
			ui.change_stamina_alpha(1.0)
		if value == 100:
			ui.change_stamina_alpha(0.0)
		stamina = clamp(value,0,100)
signal cast_spell(type: String, pos: Vector3, direction: Vector2, size: float)
func _ready():
	#print("SCENE PATH:", get_tree().current_scene.scene_file_path)
	#print("NODE PATH:", get_path())
	#print("jump_height from inspector:", jump_height)
	ui.setup(health)
	weapon_active = true

	
	skin.switch_weapon(weapon_active)
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity  = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity  = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	#print("jump_velocity computed as:", jump_velocity)
# movement direction input
var movement_input := Vector2.ZERO
var last_movement_input := Vector2(0,1)
var defend := false:
	set(value):
		if defend == value:
			return  # add this - exit if nothing changed
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value
var speed_modifier := 1.0
var weapon_active := true:
	set(value):
		weapon_active = value
		if weapon_active:
			ui.get_node("Spells").hide()
		else:
			ui.get_node("Spells").show()

func jump_logic(delta) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and stamina >= 20:
			velocity.y = -jump_velocity
			do_squash_and_streach(1.2,0.16)
			stamina -= 20
	else:
		$godetteSkin.set_move_state('Jump')
	var gravity = jump_gravity if velocity.y > 0 else fall_gravity
	velocity.y -= gravity * delta
func _physics_process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	# read input relative to camera
	# old move code
	# movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera_3d.global_rotation.y)
	#velocity = Vector3(movement_input.x,0,movement_input.y) * base_speed
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()
	physics_logic()  
	ability_logic()
	#print("jump_height NOW:", jump_height, " jv:", jump_velocity)
	#print("on_floor:", is_on_floor(), "jump_pressed:", Input.is_action_just_pressed("jump"), " jv:", jump_velocity)
	#if Input.is_action_just_pressed('ui_accept'):
		#hit()
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
		speed = defend_speed if defend else speed
		#print(speed)

		# run anim
		$godetteSkin.set_move_state('Running')
		vel_2d += movement_input * speed * delta * 8.0
		vel_2d = vel_2d.limit_length(speed) * speed_modifier

		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		var target_angle = -movement_input.angle() * PI/2
		$godetteSkin.rotation.y = rotate_toward($godetteSkin.rotation.y, target_angle, 6.0 * delta)
		
		
	
	else:
		# slow down when no input
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		# walk anim
		$godetteSkin.set_move_state('Idle')
		
	if movement_input:
			last_movement_input = movement_input.normalized()
		
	run_particles.emitting = is_on_floor() and is_running and movement_input != Vector2.ZERO
	if is_on_floor() and movement_input:
		if not $sounds/stepsound.playing:
			$sounds/stepsound.playing = true
	else:
		$sounds/stepsound.playing = false
	#$sounds/stepsound.playing = is_on_floor() and movement_input
var can_cast := true

func ability_logic() -> void:
	# attack / ability
	if Input.is_action_pressed("ability") and can_cast:
		if weapon_active:
			can_cast = false
			$godetteSkin.attack()
			$sounds/swordsound.play()
			
			await get_tree().create_timer(0.25).timeout
			can_cast = true
			
		else:
			if energy >= 20:
				can_cast = false
				
				$godetteSkin.cast_spell()
				stop_movement(0.3, 0.67)
				energy -= 20
				
				await get_tree().create_timer(0.2).timeout
				can_cast = true
			# didnt use () in cast spell
			# i fixed ability trigger was calling Skin.cast_spell instead of node instance $godetteSkin
	# defend = Input.is_action_just_pressed("block") 
	# What i fixed  Fix: block animation flickering
	# Cause: used is_action_just_pressed() so defend toggled true→false every frame; switched to is_action_pressed()
	# defend (hold-based, correct)
	defend = Input.is_action_pressed("block")

	# switch weapon
	if Input.is_action_just_pressed("switch") and not skin.attacking:
		weapon_active = not weapon_active
		skin.switch_weapon(weapon_active)
		do_squash_and_streach(1.2, 0.16)

	# switch spell
	if Input.is_action_just_pressed("spell switch") and not skin.attacking:
		current_spell = spells[spells.keys()[(int(current_spell) + 1) % len(spells)]]
		ui.update_spell(spells, current_spell)
func stop_movement(start_duration: float , end_duration: float):
	var tween = create_tween()
	tween.tween_property(self, "speed_modifier", 0.0, start_duration      )
	tween.tween_property(self, "speed_modifier", 1.0, end_duration      )
func hit():
	if not $Timers/InvulTimer.time_left:
		
		skin.hit()
		stop_movement(0.3,0.667)
		health -= 1
		$Timers/InvulTimer.start()
func do_squash_and_streach(value: float, duration: float = 0.1):
	var tween = create_tween()
	tween.tween_property(skin, "squash_and_streach", value, duration)
	tween.tween_property(skin, "squash_and_streach", 1.0, duration * 1.8 ).set_ease(Tween.EASE_OUT)
	print("u just got squash_and_streached ")
func shoot_magic(pos: Vector3) -> void:
	if current_spell == spells.FIREBALL:
		var forward = -camera_3d.global_transform.basis.z
		forward.y = 0
		forward = forward.normalized()

		var dir_2d = Vector2(forward.x, forward.z)
		cast_spell.emit('fireball', pos, dir_2d, 1.0)

	if current_spell == spells.HEAL:
		health += 1
		skin.heal_tween()


func _on_energy_recovery_timer_timeout() -> void:
	energy += 1


func _on_stamina_recovery_timer_timeout() -> void:
	stamina += 1
func physics_logic() -> void:
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody3D:
			collider.apply_central_impulse(-get_slide_collision(i).get_normal() )
