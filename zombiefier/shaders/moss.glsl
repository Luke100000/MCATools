extern Image mask;
extern vec2 offset;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
	vec4 c = Texel(tex, tc);
	vec4 b = Texel(mask, tc + offset);
	return vec4(
		b.rgb,
		b.a * c.a
	);
}