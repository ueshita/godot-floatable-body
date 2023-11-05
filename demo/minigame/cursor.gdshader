shader_type spatial;
render_mode unshaded, blend_mix;

void vertex() {
}

void fragment() {
	vec2 pos = (UV - vec2(0.5)) * 2.0;
	float len = length(pos);
	ALPHA = 0.5 * step(0.0, 1.0 - len) * smoothstep(0.5, 1.0, len);
	ALBEDO = vec3(0.8, 1.0, 1.8);
}

