//
// ECC Version 1.2 by Paul Flaherty (paulf@stanford.edu)
//
// Reed - Solomon Routines
//
// This file contains the actual routines to implement a Reed - Solomon (255,249,7) code.
// The encoder uses a feedback shift register generator, which systematically encodes 249
// bytes into a 255 byte block. The decoder is a classic Peterson algorithm.
//

#ifndef __RSLIB_H__
#define __RSLIB_H__

#include <stdint.h>

// Generator Polynomial Coefficients. The generator polynomial for the Reed - Solomon Code (255,249,7).
static const uint8_t g[6] = {
	117, 49, 58, 158, 4, 126
};

// The Encoder uses a shift register algorithm, as detailed in _Applied Modern Algebra_ by Dornhoff and Hohn (p.446). Note that the message is reversed in the code array; this was done to allow for (emergency) recovery of the message directly from the data stream.
void rsencode(uint8_t m[249], uint8_t c[255]);

// Polynomial Solver. Simple exhaustive search, as solving polynomials is generally NP - Complete anyway.
void polysolve(uint8_t polynom[4], uint8_t roots[3], int *numsol);

// Polynomial Evaluator, used to determine the Syndrome Vector. This is relatively straightforward, and there are faster algorithms.
uint8_t evalpoly(uint8_t p[255], uint8_t x);

// Determine the Syndrome Vector. Note that in s[0] we return the OR of all of the syndromes; this allows for an easy check for the no - error condition.
void syndrome(uint8_t c[255], uint8_t s[7]);

// Determine the number of errors in a block. Since we have to find the determinant of the S[] matrix in order to determine singularity, we also return the determinant to be used by the Cramer's Rule correction algorithm.
int errnum(uint8_t s[7], uint8_t *det);

// Full impementation of the three error correcting Peterson decoder. For t<6, it is faster than Massey - Berlekamp. It is also somewhat more intuitive.
int rsdecode(uint8_t code[255], uint8_t mesg[249]);

#endif
