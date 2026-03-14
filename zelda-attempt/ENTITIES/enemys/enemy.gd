class_name Enemy
extends CharacterBody3D

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group('Player')
