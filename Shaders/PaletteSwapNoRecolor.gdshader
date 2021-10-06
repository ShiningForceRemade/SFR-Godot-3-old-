shader_type canvas_item;


uniform vec4 original_0: hint_color;
uniform vec4 original_1: hint_color;
uniform vec4 original_2: hint_color;
uniform vec4 original_3: hint_color;
uniform vec4 original_4: hint_color;
uniform vec4 original_5: hint_color;
uniform vec4 original_6: hint_color;
uniform vec4 original_7: hint_color;
uniform vec4 replace_0: hint_color;
uniform vec4 replace_1: hint_color;
uniform vec4 replace_2: hint_color;
uniform vec4 replace_3: hint_color;
uniform vec4 replace_4: hint_color;
uniform vec4 replace_5: hint_color;
uniform vec4 replace_6: hint_color;
uniform vec4 replace_7: hint_color;

const float precision = 0.1;

const int color_replacements = 8;

vec4 swap_color(vec4 color){
	vec4 original_colors[8] = vec4[8] (original_0, original_1, original_2, original_3, original_4, original_5, original_6, original_7);
	vec4 replace_colors[8] = vec4[8] (replace_0, replace_1, replace_2, replace_3, replace_4, replace_5, replace_6, replace_7);
	for (int i = 0; i < 8; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}