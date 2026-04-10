shader_type spatial;
render_mode cull_disabled;
uniform vec3 color: source_color;
uniform vec3 shadow_color: source_color;
uniform sampler2D curve_Sampler: repeat_disable;
uniform sampler2D wind_sampler: repeat_enable, filter_linear;
void vertex() {
	
}

void fragment() {
		ALBEDO = mix(color, shadow_color,UV.y);
		
}

