extends Node3D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = $RayCast3D.get_collider()
	print(collider)
	
