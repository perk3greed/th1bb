shader_type canvas_item;

uniform sampler2D texttest;


float randomize(vec2 number) {
	return fract(sin(dot(number,vec2(1235.2364,1743.5429)))*43871.312);
	
	
} 




float rndfl(float numberd) {
	return fract((sin(numberd))*43871.312);
	
	
}

void fragment() {
	float currpoint;
	vec4 customtextr;
	vec2 ramdvectr;
	float randmstepping;
	vec2 ran_cur_UV;
	float pos_calced;
	vec2 realpoint;
	
	float random_time = (sin(TIME) + 1.0)/2.0;
	float time_ztoH = floor(sin(TIME/120.0)*60.0);
	customtextr = vec4(0.0,0.0,0.0,1.0);
	randmstepping = step(rndfl(floor(UV.x*12.0)*time_ztoH),abs(UV.y*8.0-4.0));
	ramdvectr = vec2((sin(2) + 1.0)/2.0, 1.0);
	currpoint = step(rndfl(floor(1.0+UV.x*12.0)*time_ztoH),abs(UV.y*8.0-4.0));
	ran_cur_UV = vec2((floor(UV.x*100.0)/100.0),rndfl(floor(UV.x*100.0))/100.0);
	
	realpoint = vec2((floor(UV.x*10.0)/10.0),floor(UV.y*10.0)/10.0);
	pos_calced = smoothstep(realpoint.x,realpoint.y,abs(UV.y - 0.5 - sin(UV.x*60.0)*0.4*random_time));
	
	COLOR = vec4(vec3(1.0), 1.0);
	
	
	
	//COLOR = vec4(vec3(smoothstep(randmstepping,currpoint,smoothstep(1.0,0.0,fract(UV.x*12.0)))),1.0);
	//COLOR = vec4(vec3(smoothstep(rndfl(floor(realpoint.x*60.0)+ rndfl(floor(TIME/12.0))),
	//rndfl(floor(60.0+realpoint.x*60.0)+rndfl(floor(TIME/12.0))),fract(UV.y*10.0)*1.0)),1.0);
	}
	
	