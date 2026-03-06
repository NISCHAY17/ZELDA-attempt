extends MeshInstance3D
@onready var mesh_instance_3d_2: MeshInstance3D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello world")
	
	
	
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color.AQUA
	pass # Replace with function body.

func  _physics_process(delta: float) -> void:
	rotation_degrees += Vector3(0,0,0)
	position += Vector3(0,0,0) * delta
	scale += Vector3(0.001,0.001,0.001)
	mesh.radius += 0.1 * delta
	mesh.height += 0.9 * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
