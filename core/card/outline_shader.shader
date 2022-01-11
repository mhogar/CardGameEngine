shader_type canvas_item;

uniform vec4 line_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform bool show_outline = false;

const float line_thickness = 1.0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if (show_outline) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		outline = min(outline, 1.0);
		
		COLOR = mix(COLOR, line_color, outline - COLOR.a);
	}
}