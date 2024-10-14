#define DIFF_COEF_SUM      (DIFF_COEF_CENTER + DIFF_COEF_DIAG * 4.)
#define GET_ERROR(offset)  texture(iChannel1, (fragCoord + vec2 offset) / iResolution.xy).z

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    if (fragCoord.x > (iMouse.xy != vec2(0) ? iMouse.x : iResolution.x * .5)) {
        vec3 col = texture(iChannel0, fragCoord / iResolution.xy).rgb;
      #if defined(GAMMA_FACTOR)
        col = pow(col, vec3(GAMMA_FACTOR));
      #endif
        float brightness = dot(col,vec3(0.2988, 0.5869, 0.1143));
        float i = step(texture(iChannel2, mod(fragCoord,1024.) / 1024.).r, brightness);
        fragColor = vec4(i);
        return;
    }
    
#if defined(INPUT_GRADIENT)
    float brightness = fragCoord.x / iResolution.x;
#else
    vec3 col = texture(iChannel0, fragCoord / iResolution.xy).rgb;

  #if defined(GAMMA_FACTOR)
    col = pow(col, vec3(GAMMA_FACTOR));
  #endif
    float brightness = dot(col,vec3(0.2988, 0.5869, 0.1143));
#endif

#if defined(FEED_NOISE_ON_START)
    if (iFrame == 0) {
        brightness = hash12(iResolution.xy - fragCoord);
    }
#endif

#if defined(NOISE_FACTOR)
    brightness += hash12(fragCoord) * 2. * NOISE_FACTOR - NOISE_FACTOR;
#endif
    
    float prevResult = texture(iChannel1, fragCoord / iResolution.xy).x;
    
    float errorUL = GET_ERROR((-.5,-.5));
    float errorUR = GET_ERROR(( .5,-.5));
    float errorDL = GET_ERROR((-.5, .5));
    float errorDR = GET_ERROR(( .5, .5));
    
    float errorSum = (errorUL + errorUR + errorDL + errorDR) * DIFF_COEF_DIAG;

    float correctedBrightness = brightness - errorSum * ERROR_FEEDBACK;
    
    float th = step(prevResult, THRESH_LVL) * THRESH_HYST * 2. - THRESH_HYST + THRESH_LVL;
    float result = step(th, correctedBrightness);
    float error = result - correctedBrightness;
    float resultError = (errorSum + error * DIFF_COEF_CENTER) / DIFF_COEF_SUM;

    fragColor = vec4(result, correctedBrightness, resultError * ERROR_ATTENUATION, 1.0);
}
