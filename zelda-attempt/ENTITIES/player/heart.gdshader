shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.0);
uniform float progress: hint_range(0.0,1.0) = 0.0;
uniform float alpha: hint_range(0.0,1.0) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
