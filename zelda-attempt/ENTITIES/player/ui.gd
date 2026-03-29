extends Control


@onready var heart_container = $Control/MarginContainer/HBoxContainer/Heart
var heart_scene: PackedScene = preload('res://ENTITIES/player/heart.tscn')

func setup(value: int) -> void:
	for i in value:
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
		heart.change_alpha(1.0)
		await get_tree().create_timer(0.3).timeout
