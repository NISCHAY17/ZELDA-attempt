extends Enemy

const simple_attacks
func  _physics_process(delta: float) -> void:
	move_to_player(delta)
func _on_attack_timer_timeout() -> void:
	if position.distance_to(player.position) < 5.0:	
		melee_attack_animation()
	
	# 4 anim
	# 2 melee attacks
	# 2 range attacks
func melee_attack_animation():
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
