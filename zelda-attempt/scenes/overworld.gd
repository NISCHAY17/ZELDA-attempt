extends Level

func _on_castle_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass


func _on_castle_area_body_entered(_body: Node3D) -> void:
	switch_level("dungeon")
