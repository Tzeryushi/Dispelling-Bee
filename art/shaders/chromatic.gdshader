shader_type canvas_item;

uniform bool apply = true;
uniform float amount = 1.0;
uniform sampler2D offset_texture : hint_white;

uniform float outline_width = 2.0;
uniform vec4 outline_color: hint_color;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float a;
	float maxa = texture_color.a;
	float mina = texture_color.a;
	
	vec4 color = texture_color;
	
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
	
	color = mix(color, outline_color, maxa - mina);
	
	if (apply == true) {
		float adjusted_amount = amount * texture(offset_texture, UV).r / 100.0;
		color.r = texture(TEXTURE, vec2(UV.x + adjusted_amount, UV.y)).r;
		color.g = texture(TEXTURE, UV).g;
		color.b = texture(TEXTURE, vec2(UV.x - adjusted_amount, UV.y)).b;
	}
	
	COLOR = color;
}