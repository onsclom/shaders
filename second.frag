#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

void main() {

    vec2 st = gl_FragCoord.xy/u_resolution;

    float a = abs(sin(u_time*.6))*.25;
    float b = abs(sin(u_time*.5))*.25;
    float c = abs(sin(u_time*.4))*.25;

    float a2 = st.x;
    float b2 = st.y;



	gl_FragColor = vec4(
    (a+a2)/2.0,
    (b+b2)/2.0,
    c,
    1.0);
}
