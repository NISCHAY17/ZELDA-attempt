class_name Enemy
extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group('Player')
@onready var skin = get_node('skin')

@export var walk_speed := 2
func move_to_player(delta):
	var target_dir = ( player.position - position ).normalized()
	var target_vec2 = Vector2(target_dir.x, target_dir.z   )
	velocity = Vector3(target_vec2.x, 0 , target_vec2.y) * walk_speed
	move_and_slide()
	
