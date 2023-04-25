shader_type canvas_item;

uniform vec4 color_blend_target: source_color = vec4(1.0);
uniform float blend_strength_modifier: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, color_blend_target.rgb, blend_strength_modifier);
	COLOR = color;
}