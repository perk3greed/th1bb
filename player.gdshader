shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	float horisontal_pass;
	float ver_pass;
	ver_pass = clamp(sin(TIME),0.6,0.9);
	horisontal_pass = clamp(cos(TIME),0.6,0.9);
	
	COLOR = vec4(VERTEX.x*horisontal_pass/1280.0,0.0,VERTEX.y*ver_pass/720.0,COLOR.a);
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
