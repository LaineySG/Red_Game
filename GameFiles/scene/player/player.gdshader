shader_type canvas_item;
render_mode blend_mix;

uniform bool enable_disintegrate = false;
uniform bool enable_offset_shadow = false;
uniform bool enable_blur = false;
uniform bool enable_outline = false;
uniform bool enable_sil = false;

//disintegrate
uniform float amount = 20.0;
//disintegrate

// offsetshadow
uniform vec2 offset = vec2(8.0, 8.0);
uniform vec4 offset_shadow_modulate : source_color;
// offsetshadow

//silhouette
uniform vec4 modulate: source_color;
//solhouette

//blur
uniform float radius = 20.0;
//blur

//outline
uniform float outline_width = 2.0;
uniform vec4 outline_color: source_color;
//outline


void fragment() {

vec4 current_pixel = texture(TEXTURE, UV);
vec4 modulated = COLOR - current_pixel;
	
// offsetshadow
if (enable_offset_shadow) {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec4 shadow = vec4(offset_shadow_modulate.rgb, texture(TEXTURE, UV - offset * ps).a * offset_shadow_modulate.a);
	vec4 col = texture(TEXTURE, UV);
	COLOR = mix(shadow, col, col.a) + modulated;
	}
// offsetshadow

//disintegrate
if (enable_disintegrate) {
	vec2 uv = UV * 0.05;
	float a = fract(sin(dot(UV, vec2(12.9898, 78.233))) * 438.5453);
	vec4 col2 = texture(TEXTURE, UV);

	col2.a *= pow(a, amount);

	COLOR = col2 + modulated;
	}
//disintegrate

//blur
if (enable_blur) {
	
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;

	col += texture(TEXTURE, UV + vec2(0.0, -radius) * ps);
	col += texture(TEXTURE, UV + vec2(0.0, radius) * ps);
	col += texture(TEXTURE, UV + vec2(-radius, 0.0) * ps);
	col += texture(TEXTURE, UV + vec2(radius, 0.0) * ps);
	col /= 5.0;

	COLOR = col + modulated;
}
//blur

//outline

	if (enable_outline) {
		
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float a;
	float maxa = col.a;
	float mina = col.a;

	a = texture(TEXTURE, UV + vec2(0.0, -outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(0.0, outline_width) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(-outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	a = texture(TEXTURE, UV + vec2(outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	mina = min(a, mina);

	COLOR = mix(col, outline_color, maxa - mina) + modulated;
	}
//outline

//sil
if (enable_sil) {
	COLOR = vec4(modulate.rgb, texture(TEXTURE, UV).a * modulate.a) + modulated;
}
	//sil

}
