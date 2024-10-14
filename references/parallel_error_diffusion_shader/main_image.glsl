void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    fragColor = vec4(vec3(texture(iChannel0, fragCoord / iResolution.xy).x),1.);
    //fragColor = vec4(vec3(texture(iChannel0, fragCoord / iResolution.xy).z*.5+.5),1.);
}