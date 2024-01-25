shader_type canvas_item;


// Changes hue, saturation and value of input color.
// [hue] will be added to [color] hue, so [col].hue = [color].hue + [hue].
//[color] saturation and value will be multiplied by [sat] and [value], so [col].saturation(OR)value = [color].saturation(OR)value +* [sat](OR)[value]

uniform float hue = 0.0;
uniform float sat = 1.0;
uniform float value = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// thanks plugin from github that I stole this from
vec3 hsvChange(vec3 _color_HSVChange, float _h_HSVChange, float _s_HSVChange, float _v_HSVChange){
	// RGB2HSV
	vec3 c = _color_HSVChange;
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	c = vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	
	c.r += _h_HSVChange;
	c.g *= _s_HSVChange;
	c.b *= _v_HSVChange;
	float my_hue = c.r + _h_HSVChange;
	c.x = (my_hue < 0.0) ? my_hue + 1.0 : ((my_hue > 1.0) ? my_hue - 1.0 : my_hue);
	
	// HSV2RGB
	K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p2 = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	c = c.z * mix(K.xxx, clamp(p2 - K.xxx, 0.0, 1.0), c.y);
	
	return c;
}

void fragment() {
	COLOR.rgb = hsvChange(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, hue, sat, value);
}

