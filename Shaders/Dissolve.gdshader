shader_type canvas_item;

uniform float dissolve_effect_amount: hint_range(0,1);
uniform sampler2D noise_texture;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	vec4 noise_pixel   = texture(noise_texture, UV);
	
	if(noise_pixel.r < dissolve_effect_amount) {
		COLOR.a -= 1.0f;
	} else {
		COLOR = current_pixel;
	}
}