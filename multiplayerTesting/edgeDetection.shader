shader_type canvas_item;

uniform float leniancy;

void fragment() {
    vec3 col = -8.0 * texture(TEXTURE, SCREEN_UV).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
    col += texture(TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE.xy).xyz;
    col += texture(TEXTURE, SCREEN_UV - SCREEN_PIXEL_SIZE.xy).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz;
    col += texture(TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz;

	
	//COLOR.xyz = col;
	
	float avg = (abs(col.x)+abs(col.y)+abs(col.z));
	avg /= 3.0;
	
	COLOR.xyz = vec3(avg);
	
	avg = step(leniancy, avg);
	
    COLOR.xyz = vec3(avg)*vec3(0.0) + (1.0-avg)*texture(TEXTURE, SCREEN_UV).xyz;
	 COLOR.xyz = vec3(avg)*vec3(0.0) + (1.0-avg)*vec3(1.0);
	
	
	//if 
}