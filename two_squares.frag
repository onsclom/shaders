#ifdef GL_ES
precision mediump float;
#endif

//changes color using mouse location and time

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
	vec2 st = u_mouse/u_resolution;
	gl_FragColor = vec4(st.x,st.y,sin(u_time/25.0),1.0);
}
