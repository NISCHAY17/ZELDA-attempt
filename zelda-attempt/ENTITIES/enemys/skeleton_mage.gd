extends Enemy
signal cast_spell(type: String, pos: Vector3, direction: Vector2, size: float)

func _ready() -> void:
	attack_radius = 1.5


func _physics_process(delta: float) -> void:
	move_to_player(delta)

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time  = rng.randf_range(2.5,3.5)
	if position.distance_to(player.position) < attack_radius:
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE   )

func shoot_fireball() -> void:
	cast_spell.emit('fireball')
