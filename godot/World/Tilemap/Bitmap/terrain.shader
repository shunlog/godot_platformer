shader_type canvas_item;

uniform sampler2D t1;
uniform sampler2D t2;

void fragment(){
	vec4 col1 = texture(t1, vec2(UV.x, 0.0));
	vec4 col2 = texture(t2, vec2(UV.x, 0.3));
	vec4 col = (col1 + col2) / 2.0;
	if (UV.y < col.r){
		col = vec4(1.0);
	} else {
		col = vec4(0.0, 0.0, 0.0, 1.0);
	}
	COLOR = col;
}
