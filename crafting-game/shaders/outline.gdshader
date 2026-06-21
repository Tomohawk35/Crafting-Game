shader_type canvas_item;

// reference https://www.youtube.com/watch?v=58ytpFZ0re0

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0.0, 1.0) = 0.5;
const float max_line_thickness = 2.0;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	if (line_thickness > 0.0) {
		float outline = color.a;
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness * max_line_thickness;
		for (float y = -1.0; y <= 1.0; y++) {
			for (float x = -1.0; x <= 1.0; x++) {
				vec2 offset = vec2(x, y) * size;
				outline += texture(TEXTURE, UV + offset).a;
			}
		}
		outline = min(outline, 1.0);
		COLOR = mix(color, line_color, outline - color.a);
	}
}