#define MT
#define PBC
#define QSAP_TANH
// #define QSAP_EXP
// #define QSAP_ZERO_LINEAR
// #define QSAP_ZERO_SMOOTH
// #define POSITION_DEPENDENT_SPEED
#if defined(QSAP_TANH) || defined(QSAP_EXP) || defined(QSAP_ZERO)
#define QSAP
#endif
#define HASHING
#define DENSITY_HISTOGRAM
#define WALL

// #define HARMONIC
// #define WCA
#if defined(HARMONIC) || defined(WCA)
#define PFAP
#define STRESS_TENSOR
#endif
// #define TESTING_DENSITY
// #define TESTING_FORCE


/*
Exit codes:
Nevermind it's just 1
1: Incorrect input
2: Incompatible parameters
3: Memory allocation failed
4: Error arise in initializing
5: Error arise in simulation
*/
