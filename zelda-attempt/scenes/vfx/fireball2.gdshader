shader_type spatial;

uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_sampler : filter_linear, source_color;
void fragment() {
	float noise = texture(noise_sampler, UV - vec2(0.0, TIME)).x;
	vec3 gradient = texture(gradient_sampler, UV).rgb;
	ALBEDO = gradient;
}