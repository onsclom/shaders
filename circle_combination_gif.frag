precision highp float;

#define M_PI 3.14159265358979323846

varying vec2 UV;
uniform vec2 iResolutionAttribute;
uniform float iGlobalTime;
uniform float ratio;

void main(){
	vec2 st = UV*ratio;
    float pct = 0.0;

    float circleDistance = 4.;
    float circleSize = .2;
    
    // a. The DISTANCE from the pixel to the center
        
    float curX = .5 + sin(iGlobalTime*.33)/circleDistance;
    float curY = .5 + cos(iGlobalTime*.33)/circleDistance;
    
    pct = distance(st,vec2(curX, curY));
    pct = step(pct, circleSize);
    
    float cur2X = .5 + sin(iGlobalTime*.33+90.)/circleDistance;
    float cur2Y = .5 + cos(iGlobalTime*.33+90.)/circleDistance;
    
    float pct2 = distance(st,vec2(cur2X, cur2Y));
    pct2 = step(pct2, circleSize);
    
    float cur3X = .5 + sin(iGlobalTime*.33+180.)/circleDistance;
    float cur3Y = .5 + cos(iGlobalTime*.33+180.)/circleDistance;
    
    float pct3 = distance(st,vec2(cur3X, cur3Y));
    pct3 = step(pct3, circleSize);
    
    
    //fade stuff

    float a = abs(sin(iGlobalTime*.4));
    float b = abs(sin(iGlobalTime*.3));
    float c = abs(sin(iGlobalTime*.2));

    float a2 = st.x*.25;
    float b2 = st.y*.25;



	gl_FragColor = vec4(
    (a+a2)/2.0,
    (b+b2)/2.0,
    c,
    1.0);


	vec4 gradient = vec4(
    (a+a2)/2.0,
    (b+b2)/2.0,
    c,
    1.0);




    vec3 color = vec3(pct + pct2 + pct3);
	vec3 colorInverse = vec3(1) - vec3(pct + pct2 + pct3);
    
	gl_FragColor = vec4( color, 1.0 ) * gradient + vec4(colorInverse, 1.0) * gradient * .2;
}
