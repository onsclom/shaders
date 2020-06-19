#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);

    // bottom-left
    vec2 bl = step(vec2(0.05),st);
    float pct = bl.x * bl.y;

     //top-right
     vec2 tr = step(vec2(0.5),1.0-st);
     pct *= tr.x * tr.y;
    
    //now for the right square
    // bottom-left
    vec2 bl2 = step(vec2(.5),st);
    float pct2 = bl2.x * bl2.y;
    
    vec2 tr2 = step(vec2(0.05),1.0-st);
    pct2 *= tr2.x * tr2.y;

    color = vec3(pct2 + pct);

    gl_FragColor = vec4(color,0.632);
}