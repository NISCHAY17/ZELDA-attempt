extends Node3D

@onready var move_state_machine =  $AnimationTree.get("parameters/MOVEStateMachine/playback")
@onready var attack_state_machine =  $AnimationTree.get("parameters/AttackStateMachine/playback")

var attacking := false


func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)




func attack():
	if not attacking:
		attack_state_machine.travel('Slice' if $SecondHandTimer.time_left else 'Chop')
		$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func attack_toggle(value: bool):
	attacking = value
func defend(forward: bool) -> void:
	var tween = create_tween()
	tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)
func switch(weapon_active: bool) -> void:
	if weapon_active:
		$Rig/Skeleton3D/RightHandSlot/sword_1handed2.show()
		$Rig/Skeleton3D/RightHandSlot/wand2.hide()
	else:
		$Rig/Skeleton3D/RightHandSlot/sword_1handed2.hide()
		$Rig/Skeleton3D/RightHandSlot/wand2.show()
func Cast_spell() -> void:
	if not attacking:
		$AnimationTree.set("parameters/ExtraOneshot/active" , AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)  
func _defend_change(value: float) -> void:
	# print("Shield blend:", value) used for testing click value 
	$AnimationTree.set("parameters/ShieldBlend/blend_amount", value)
	
