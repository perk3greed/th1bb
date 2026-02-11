shader_type canvas_item;

uniform sampler2D texttest;


void fragment() {
	float horisontal_pass;
	float ver_pass;
	vec4 cur_UV;
	vec4 testure;
	float currpoint;
	vec4 curvect;
	vec4 customtextr;
	vec4 stepping;
	vec2 ramdvectr;
	vec2 randmstepping;
	vec2 ran_cur_UV;
	ver_pass = clamp(sin(TIME),0.2,0.9);
	horisontal_pass = clamp(cos(TIME*2.0),0.2,0.9);
	testure = texture(texttest,SCREEN_UV);
	currpoint = (sin(TIME) - 1.0)/2.0;
	curvect = vec4((sin(TIME) + 1.0)/2.0, (sin(TIME) + 1.0)/2.0, (sin(TIME) + 1.0)/2.0, 1.0);
	float dist = distance(testure,vec4(UV-vec2(0.4,0.4),0.0,1.0))*2.0;
	float clamped = min(dist , 0.74);
	customtextr = vec4(0.0,0.0,0.0,1.0);
	cur_UV = vec4(UV.x*12.0+ 0.5*step(1.0,mod(UV.y*1.0,2.0)),0.0,UV.y*0.0 , 1.0);
	stepping = step(fract(cur_UV),curvect);
	randmstepping = step(fract(UV*12.0),ramdvectr);
	ramdvectr = vec2((sin(2) + 1.0)/2.0, 1.0);
	ran_cur_UV = vec2(UV*1.0);


	//COLOR = vec4(mix(COLOR,customtextr,stepping));
	//currpoint = fract(sin(dot(UV,vec2(123.2127,211.53429)))*4338.3);
	//COLOR = vec4(vec3(currpoint),1.0);
	//COLOR = vec4()
	//step(mod(cur_UV,1.0),curvect) )
	//COLOR = vec4(mix(COLOR.r,testure.r,step(mod(cur_UV.y,1.0),currpoint)),mix(COLOR.g,testure.g,step(mod(cur_UV.y,1.0),currpoint)),mix(COLOR.b,testure.b,step(mod(cur_UV.y,1.0),currpoint)),COLOR.a);
	//COLOR = vec4(smoothstep(testure.r,COLOR.r,horisontal_pass)r, smoothstep(testure.g,COLOR.g,ver_pass), smoothstep(testure.b,COLOR.b,ver_pass), COLOR.a);
	//COLOR = vec4(step(dist+ver_pass,0.8),0.0,0.6,COLOR.a);

	//COLOR = vec4(clamp(COLOR,horisontal_pass,ver_pass));
	//COLOR = vec4(VERTEX.x*horisontal_pass/1280.0,0.0,VERTEX.y*ver_pass/720.0,COLOR.a);
}