shader_type canvas_item;

uniform vec4 origin:source_color;
uniform vec4 new:source_color;

void fragment() {
	
	vec4 current_pixel = texture(TEXTURE, UV);
	vec4 modulate = COLOR - current_pixel;
	if ((distance(current_pixel, origin) < 0.1))
		COLOR = new;
	else
		COLOR = current_pixel + modulate;
}
