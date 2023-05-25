shader_type canvas_item;

uniform sampler2D t1;
uniform float f1 = 1.;
uniform sampler2D t2;
uniform float f2 = 1.;
uniform sampler2D t3;
uniform float f3 = 1.;
uniform sampler2D t4;
uniform float f4 = 1.;
uniform float step = .5;


void fragment(){
	vec4 col1 = texture(t1, vec2(UV));
	vec4 col2 = texture(t2, vec2(UV));
	vec4 col3 = texture(t3, vec2(UV));
	vec4 col4 = texture(t4, vec2(UV));
	
	vec4 col = (col1 * f1 + col2 * f2 + col3 * f3 + col4 * f4) / (f1 + f2 + f3 + f4);
	COLOR = vec4(vec4(vec4(1.0) - step(step, col)).xyz, 1.0);
}
