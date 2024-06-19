//
//  UIColorMixing.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>


//
// from: https://github.com/ddelruss/UIColor-Mixing
// thanks Damien Del Russo
//

@interface UIColor (Mixing)

+ (UIColor*) rybColorWithRed:(CGFloat)red
					  yellow:(CGFloat)yellow
						blue:(CGFloat)blue
					   alpha:(CGFloat)alpha;
+ (UIColor*) cmykColorWithCyan:(CGFloat)cyan
					   magenta:(CGFloat)magenta
						yellow:(CGFloat)yellow
						 black:(CGFloat)black
						 alpha:(CGFloat)alpha;
- (void) rybRed:(CGFloat*)red
		 yellow:(CGFloat*)yellow
		   blue:(CGFloat*)blue
		  alpha:(CGFloat*)alpha;
- (void) cmykCyan:(CGFloat*)cyan
		  magenta:(CGFloat*)magenta
		   yellow:(CGFloat*)yellow
			black:(CGFloat*)black
			alpha:(CGFloat*)alpha;

+ (UIColor*) rgbMixForColors:(NSArray*)arrayOfColors;		// mix as light, additive. fundamentally RGB doesn't mix differently than RYB
+ (UIColor*) rybMixForColors:(NSArray*)arrayOfColors;		// mix as physical material, averaging brightness
+ (UIColor*) cmykMixForColors:(NSArray*)arrayOfColors;

@end
