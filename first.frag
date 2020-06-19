#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;

void main() {
	gl_FragColor = vec4(abs(sin(u_time*.6))*.1,abs(sin(u_time*.5))*.1,abs(sin(u_time*.4))*.1,1.0);
}
