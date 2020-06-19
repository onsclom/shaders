// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution;
    float pct = 0.0;

    float circleDistance = 4.;
    float circleSize = .2;
    
    // a. The DISTANCE from the pixel to the center
        
    float curX = .5 + sin(u_time*.33)/circleDistance;
    float curY = .5 + cos(u_time*.33)/circleDistance;
    
    pct = distance(st,vec2(curX, curY));
    pct = step(pct, circleSize);
    
    float cur2X = .5 + sin(u_time*.33+90.)/circleDistance;
    float cur2Y = .5 + cos(u_time*.33+90.)/circleDistance;
    
    float pct2 = distance(st,vec2(cur2X, cur2Y));
    pct2 = step(pct2, circleSize);
    
    float cur3X = .5 + sin(u_time*.33+180.)/circleDistance;
    float cur3Y = .5 + cos(u_time*.33+180.)/circleDistance;
    
    float pct3 = distance(st,vec2(cur3X, cur3Y));
    pct3 = step(pct3, circleSize);
    
    

    vec3 color = vec3(pct + pct2 + pct3);

	gl_FragColor = vec4( color, 1.0 );
}
