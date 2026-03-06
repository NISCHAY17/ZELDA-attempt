extends Node3D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y += event.relative.x * 0.0067
		
func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	rotation.y += v.x
	
