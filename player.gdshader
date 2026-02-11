shader_type canvas_item;

uniform sampler2D texttest;
uniform sampler2D verture;

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	float horisontal_pass;
	float ver_pass;
	vec4 testure;
	ver_pass = clamp(sin(TIME),0.2,0.9);
	horisontal_pass = clamp(cos(TIME),0.2,0.9);
	testure = texture(texttest,SCREEN_UV);
	COLOR = vec4(testure.r, testure.g, testure.b, COLOR.a);
	float dist = distance(COLOR,vec4(UV-vec2(0.5,0.5),0.0,1.0))*3.0;
	float clamped = min(dist, 1.3);
	//COLOR = vec4(step(clamped,0.9),0.0,0.6,COLOR.a);
	//COLORggg = vec4(clamp(COLOR,horisontal_pass,ver_pass));
	//COLOR = vec4(VERTEX.x*horisontal_pass/1280.0,0.0,VERTEX.y*ver_pass/720.0,COLOR.a);
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
