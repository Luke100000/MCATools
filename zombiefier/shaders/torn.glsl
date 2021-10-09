extern Image mask;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
	vec4 c = Texel(tex, tc);
	vec4 b = Texel(mask, tc);
	
	return vec4(
		c.rgb * mix(vec3(1.0), b.rgb * 1.5, 0.75),
		b.a * c.a
	);
}