extends Node3D

var can_damage := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_damage:
		var collider = $RayCast3D.get_collider()

	
