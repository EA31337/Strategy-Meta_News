/**
 * @file
 * Defines conditional compilation directives.
 *
 * Uncomment a line to activate the feature.
 */

// @todo: Remove me.
#ifndef STG_AC_INDI_FILE
#ifdef __MQL4__
#define STG_AC_INDI_FILE "\\Indicators\\Accelerator.ex4"
#else
#define STG_AC_INDI_FILE "\\Indicators\\Examples\\Accelerator.ex5"
#endif
#endif

// @todo: Remove me.
#ifndef STG_AD_INDI_FILE
#ifdef __MQL4__
#define STG_AD_INDI_FILE "\\Indicators\\Accumulation.mq4"
#else
#define STG_AD_INDI_FILE "\\Indicators\\Examples\\AD.ex5"
#endif
#endif

// #define __debug__        // Enables debugging.
// #define __input__        // Enables input parameters.
#define __input2__  // Enables 2nd level of input parameters.
// #define __optimize__     // Enables optimization mode.
// #define __resource__  // Enables resources.
// #define __strategies__  // Enables local strategies includes.
// #define __strategies_meta__  // Enables local meta strategies includes.
