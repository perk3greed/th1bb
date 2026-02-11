shader_type canvas_item;

uniform sampler2D texttest;


float randomize(vec2 number) {
	return fract(sin(dot(number,vec2(1235.2364,1743.5429)))*43871.312);
	
	
} 

float randomize_float(float numberd) {
	return fract((sin(numberd))*43871.312);
	
	
}

void fragment() {
	float currpoint;
	vec4 customtextr;
	vec2 ramdvectr;
	vec2 randmstepping;
	vec2 ran_cur_UV;
	float pos_calced;
	
	float random_time = (sin(TIME) + 1.0)/2.0;
	float time_ztoH = sin(TIME/40.0)*120.0;
	customtextr = vec4(0.0,0.0,0.0,1.0);
	randmstepping = step(fract(UV*12.0),ramdvectr);
	ramdvectr = vec2((sin(2) + 1.0)/2.0, 1.0);
	
	ran_cur_UV = (vec2(UV*cos(4.0/4.0)*466.0+sin(22.0/20.0)*466.0));
	
	pos_calced = floor(UV.x*120.0);

	//currpoint = randomize(floor(vec2(UV.x*480.0 + (mod(floor(UV.y*4.0),2.0)*2.0 - 1.0)*time_ztoH ,UV.y*2.0)));
	
	currpoint = randomize(floor(vec2(UV.x*120.0 + (mod(floor(UV.y*60.0),4.0)*2.0 - 1.0)*time_ztoH ,UV.y*60.0)));
	
	COLOR = vec4(vec3(step(0.2,currpoint)),1.0);

}