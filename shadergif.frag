#version 300 es
#define M_PI 3.1415926535897932384626433832795
precision highp float;

in vec2 UV;
uniform vec2 mouse;
out vec4 out_color;
uniform float ratio, time, iGlobalTime;

void main(void){
    
    vec2 pos = UV;
    
    float hSpeed = fract(time*1.5);
    float vSpeed = fract(time*2.0);
    
    //how many times to repeat
    pos*=4.5;
    pos.x -= hSpeed;
    
    pos = fract(pos);
    
    float odds = step(pos.x, .5)*step(.5,pos.y);
    
    float evenValue = time;
    
    float evens = step(pos.y, vSpeed) * step(vSpeed-.5, pos.y) * step(.5,pos.x)
        +
        step(pos.y, vSpeed+1.) * step(vSpeed+1.-.5, pos.y) * step(.5,pos.x);
    
    float isCheckered = odds+evens;
    
    //float colorNum =  sin( time*2.*M_PI / (10./(2*M_PI))/2. ) + .5
    float speed = 2.5;
    float colorNum = sin( iGlobalTime/(10./ (2.*M_PI) )) / 4. + .5;
    float colorNum2 = sin( iGlobalTime/(10./ (2.*M_PI) ) + .66 * M_PI ) /4. + .5;
    float colorNum3 = sin( iGlobalTime/(10./ (2.*M_PI) ) + .66 * 2. * M_PI ) /4. + .5;
    
    float test = sin(iGlobalTime/(10./ (2.*M_PI) ))/2. + .5;
    
    vec3 colorMul = vec3(colorNum, colorNum2, colorNum3);
    
    float checkInverse = 1.-isCheckered;
    vec3 colorInv = vec3(1.) - colorMul;
    
    
    colorMul *= isCheckered;
    
    
    
	out_color = vec4(colorMul + checkInverse*colorInv, 1.);
    
}
