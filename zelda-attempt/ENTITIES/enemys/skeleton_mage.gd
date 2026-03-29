extends Enemy
signal cast_spell(type: String, pos: Vector3, direction: Vector2, size: float)

func _ready() -> void:
	attack_radius = 10.5


func _physics_process(delta: float) -> void:
	move_to_player(delta)

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time  = rng.randf_range(2.5,4.67)
	#print($Timers/AttackTimer.wait_time )
	if position.distance_to(player.position) < attack_radius:
		#print('attack time')
		$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE   )

func shoot_fireball() -> void:
	var direction = (player.position - position).normalized()
	var dir_2d = Vector2(direction.x, direction.z)
	var pos = $skin/Rig/Skeleton3D/BoneAttachment3D/wand2/Marker3D.global_position
	cast_spell.emit('fireball', pos, dir_2d, 1.0)
 
