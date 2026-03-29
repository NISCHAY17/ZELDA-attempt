extends Node3D


var fireball_scene: PackedScene = preload("res://scenes/vfx/fireball.tscn")
func _ready() -> void:
	for entity in $entity.get_children():
		if entity.has_signal("cast_spell"):
			entity.connect("cast_spell", create_fireball)
func create_fireball(type: String, pos: Vector3, direction: Vector2, size: float):
	print('shoot fireball')
	
	var fireball = fireball_scene.instantiate()
	$Projectiles.add_child(fireball)
	fireball.global_position = pos
	fireball.direction = direction

	
	
#func _process(delta):
	#check_scale(self) used to check scale

# my cam and boss had incorrect scale ratio and my debugger was screaming
#func check_scale(node):
	#if node is Node3D:
		#if node.scale != Vector3.ONE:
			#print("Scaled node:", node.get_path(), node.scale)
	
#	for child in node.get_children():
		#check_scale(child)
#func _on_player_cast_spell(type: String, pos: Vector3, direction: Vector2, size: float) -> void:
	#var fireball = fireball_scene.instantiate()
	#$Projectiles.add_child(fireball)
	#fireball.global_position = pos
	#fireball.direction = direction
