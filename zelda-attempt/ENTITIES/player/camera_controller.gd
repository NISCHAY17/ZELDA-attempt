extends Node3D

@export var min_limit_x: float = deg_to_rad(-80.0)
@export var max_limit_x: float = deg_to_rad(80.0)
@export var mouse_acceleration := 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acceleration)

func rotate_from_vector(v: Vector2):
	if v == Vector2.ZERO:
		return

	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
