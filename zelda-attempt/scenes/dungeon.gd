extends Level
#@onready var ui = $UI


func _on_doorarea_body_entered(body: Node3D) -> void:
	switch_level('overworld')





var triggered := false

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if triggered:
		return

	triggered = true
	print("killzoneenter")

	call_deferred("_reload_scene")


func _reload_scene():
	get_tree().reload_current_scene()
