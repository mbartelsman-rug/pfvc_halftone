#define CONFIG  2
//#define INPUT_GRADIENT

#if CONFIG == 1
    // More stable, less quality, noise on start only

    #define DIFF_COEF_CENTER 1.
    #define DIFF_COEF_DIAG   0.95

    #define ERROR_FEEDBACK     .4
    #define ERROR_ATTENUATION  .88

    #define THRESH_LVL         .5
    #define THRESH_HYST        .2

    #define FEED_NOISE_ON_START
    //#define NOISE_FACTOR     0.05
    #define GAMMA_FACTOR         1.3

#elif CONFIG == 2
    // Less stable, better quality, noise used continuously

    #define DIFF_COEF_CENTER 1.
    #define DIFF_COEF_DIAG   1.

    #define ERROR_FEEDBACK     .5
    #define ERROR_ATTENUATION  .83

    #define THRESH_LVL         .5
    #define THRESH_HYST        .3

    #define FEED_NOISE_ON_START
    #define NOISE_FACTOR     0.05
    #define GAMMA_FACTOR     1.3

#endif

#if defined(NOISE_FACTOR) || defined(FEED_NOISE_ON_START)
    // Noise: 1 out, 2 in... (Dave_Hoskins)
    float hash12(vec2 p)
    {
        vec3 p3  = fract(vec3(p.xyx) * .1031);
        p3 += dot(p3, p3.yzx + 33.33);
        return fract((p3.x + p3.y) * p3.z);
    }
#endif
