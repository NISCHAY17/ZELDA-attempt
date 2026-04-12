extends Level


func _on_doorarea_body_entered(body: Node3D) -> void:
	switch_level('overworld')





func _on_area_3d_2_body_entered(body: Node3D) -> void:
	print("killzoneenter")
	get_tree().reload_current_scene()
