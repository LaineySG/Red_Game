shader_type canvas_item;

uniform vec4 origin:source_color;
uniform vec4 new:source_color;
uniform bool enable_sil = false;
//silhouette
uniform vec4 modulate: source_color;
//solhouette

void fragment() {
	

vec4 current_pixel = texture(TEXTURE, UV);
vec4 modulated = COLOR - current_pixel;
		
		//sil
if (enable_sil) {
	COLOR = vec4(modulate.rgb, texture(TEXTURE, UV).a * modulate.a) + modulated;
} else {
	if ((distance(current_pixel, origin) < 0.1))
		COLOR = new;
	else
		COLOR = current_pixel + modulated;
}
	//sil
		
}
