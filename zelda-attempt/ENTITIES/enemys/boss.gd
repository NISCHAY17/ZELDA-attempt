extends Enemy
const simple_attacks = {
	'slice' : "2H_Melee_Attack_Slice",
	'spin' : "2H_Melee_Attack_Spin" ,
	'range' : "1H_Melee_Attack_Stab" , 
}
@export var spin_speed = 6
var spinning := false
var can_damage_toggle := false
func _process(delta: float) -> void:
	attack_logic()    
func  _physics_process(delta: float) -> void:
	move_to_player(delta)
func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time - rng.randf_range(1.0,5.6)
	if position.distance_to(player.position) < 5.0:	
		melee_attack_animation()
	else:
		if rng.randi() % 2:
			range_attack_animation()
		else:
			#spin_attack_animation()
			range_attack_animation()
		# 4 anim          
		# 2 melee attacks
		# 2 range attacks
func spin_attack_animation():
	var tween = create_tween()
	tween.tween_property(self,"speed",spin_speed,0.5 )
	tween.tween_method(_spin_transition, 0.0, 1.0, 0.3 )
	$Timers/AttackTimer.stop()
	spinning = true
func _spin_transition(value: float) -> void:
	$AnimationTree.set("parameters/SpinBlend/blend_amount", value)
	can_damage_toggle = true
func range_attack_animation():
	stop_movement(1.5,1.5)
	attack_animation.animation = simple_attacks['range']
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func shoot_fireball() -> void:
	var direction = (player.position - position).normalized()
	var dir_2d = Vector2(direction.x, direction.z)
	var pos = $skin/Rig/Skeleton3D/Nagonford_Axe/Nagonford_Axe/Marker3D.global_position
	cast_spell.emit('fireball', pos, dir_2d, 4.0)
func melee_attack_animation():
	attack_animation.animation = simple_attacks['slice' if rng.randi() % 2 else 'spin']
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func _on_area_3d_body_entered(body: Node3D) -> void:
	if spinning:
		await get_tree().create_timer(rng.randf_range(1.0,2.3)).timeout
		var tween = create_tween()
		tween.tween_property(self,"speed",walk_speed,0.5 )
		tween.tween_method(_spin_transition, 1.0, 0.0, 0.3 )
		spinning = false
		can_damage_toggle = false
		$Timers/AttackTimer.start()
func hit():
	if not $Timers/InvulTimer.time_left:
		#print(" boss was hit ") 
		$Timers/InvulTimer.start()
func can_damage(value: bool) -> void:
	can_damage_toggle = value 
func attack_logic() -> void:
	# had to fix the geometry of player but now it works yayy
	if can_damage_toggle:
		var collider = $skin/Rig/Skeleton3D/Nagonford_Axe/Nagonford_Axe/RayCast3D.get_collider()
		#print(collider)
		if collider and collider.has_method("hit"):
			collider.hit()
