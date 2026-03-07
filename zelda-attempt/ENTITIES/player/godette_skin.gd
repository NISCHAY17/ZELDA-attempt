extends Node3D

@onready var move_state_machine =  $AnimationTree.get("parameters/MOVEStateMachine/playback")

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func attack():
	$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
