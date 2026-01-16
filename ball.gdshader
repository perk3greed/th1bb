shader_type canvas_item;

uniform sampler2D texttest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float horisontal_pass;
	float ver_pass;
	vec4 testure;
	ver_pass = clamp(sin(TIME),0.6,0.9);
	horisontal_pass = clamp(cos(TIME),0.6,0.9);
	testure = texture(texttest,SCREEN_UV);
	COLOR = vec4( testure.r, testure.g, testure.b,COLOR.a);
	//COLOR = vec4(VERTEX.x*horisontal_pass/1280.0,0.0,VERTEX.y*ver_pass/720.0,COLOR.a);
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
