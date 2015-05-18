void main(void)
{
    vec2  px = 1.5*(-iResolution.xy + 1.0*gl_FragCoord.xy) / iResolution.y;
    
    float id = 0.5 + 0.5*cos(iChannel0.x + sin(dot(floor(px+0.5),vec2(113.1,17.81)))*43758.545);
    
    vec3  co =  0.5 + 0.5*cos(iChannel0.x + 3.5*id + vec3(0.0,1.57,3.14) );//vec3(137.0/255.0,137.0/255.0,137.0/255.0);
    
    vec2  pa = smoothstep( 0.0, 0.2, id*(0.5 + 0.5*cos(6.2831*px)) );
    
    gl_FragColor = vec4( co*pa.x*pa.y, 1.0 );
}



//void main(void)
//{
//    vec2  px = 5.0*(-iResolution.xy + 4.0*gl_FragCoord.xy) / iResolution.y;
//    
//    float id = 0.5 + 0.5*cos(iChannel0.x + sin(dot(floor(px+0.5),vec2(113.1,17.81))));
//    
//    vec3  co = 0.5 + 0.5*cos(u_time + 3.5*id + vec3(0.0,1.57,3.14) );
//    
//    vec2  pa = smoothstep( 0.0, 0.2, id*(0.5 + 0.5*cos(6.2831*px)) );
//    
//    gl_FragColor = vec4( co*pa.x*pa.y, 1.0 );
//}