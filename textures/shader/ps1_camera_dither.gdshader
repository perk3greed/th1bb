
shader_type canvas_item;

uniform int color_depth : hint_range(1, 8) = 5;
uniform bool dithering = true;
uniform int resolution_scale = 4;

int dithering_pattern(ivec2 fragcoord) {
	const int pattern[] = {
		-4, +0, -3, +1,
		+2, -2, +3, -1,
		-3, +1, -4, +0,
		+3, -1, +2, -2
	};

	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;

	return pattern[y * 4 + x];
}

void fragment() {
	ivec2 uv = ivec2(FRAGCOORD.xy / float(resolution_scale));
	vec3 color = texelFetch(TEXTURE, uv * resolution_scale, 0).rgb;

	// Convert from 0 to 1 to 0 to 255.
	ivec3 c = ivec3(round(color * 255.0));

	// Apply the dithering.
	if (dithering) {
		c += ivec3(dithering_pattern(uv));
	}

	// Truncate from 8 bits to color_depth bits.
	c >>= (8 - color_depth);

	// Convert back to 0 to 1.
	COLOR.rgb = vec3(c) / float(1 << color_depth);
}