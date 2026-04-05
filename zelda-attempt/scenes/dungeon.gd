extends Level


func _on_doorarea_body_entered(body: Node3D) -> void:
	switch_level('overworld')
