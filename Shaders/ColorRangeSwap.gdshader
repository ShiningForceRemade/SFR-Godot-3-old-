shader_type canvas_item;

uniform float _min;
uniform float _max;
uniform vec4 color : source_color;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// ===== got those from: https://gamedev.stackexchange.com/a/75928

vec4 to_gray(vec4 tex)
{
	float avg = (tex.r + tex.g + tex.b) / 3.0;
	return vec4(vec3(avg),tex.a);
}

vec4 to_color(vec4 gray, vec4 col)
{
	return gray * col;
}

// ===== end

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);
	vec3 hsv = rgb2hsv(tex.rgb);
	
	// the .r here represents HUE, .g is SATURATION, .b is LUMINANCE
	if (hsv.r >= _min && hsv.r <= _max)
	{
		tex = to_gray(tex);
		tex = to_color(tex, color);
	}
	
	COLOR = tex;
}