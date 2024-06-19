//
//  UIImageAdditions.h
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

#import <Foundation/Foundation.h>
#import "CGDrawingAdditions.h"
#import "LibraryConfig.h"


@interface UIImage (ExtendedMethods)

+ (UIImage*) openFile:(NSString*)path;
+ (UIImage*) openFile:(NSString*)path error:(NSError**)error;
- (BOOL) saveAs:(NSString*)path;
- (BOOL) saveAs:(NSString*)path error:(NSError**)error;

- (UIImage*) stretchableImage;

- (UIImage*) subImage:(CGRect)rect;

+ (UIImage*) namedImageAtPath:(NSString*)path;

- (CGSize) realSize;
- (CGSize) orientedSize;
- (CGSize) orientedRealSize;
- (UIColor*) pixelColor:(CGPoint)point;
- (UIColor*) mergedColor;

- (CGSize) exifSize;
- (CGAffineTransform) exifTransform;
- (void) exifDrawRect:(CGRect)rect inContext:(CGContextRef)context;
- (void) exifDrawRect:(CGRect)rect inContext:(CGContextRef)context withOrientation:(UIImageOrientation)orientation;

+ (UIInterfaceOrientation) rotateOrientation:(UIInterfaceOrientation)orientation rotation:(UIInterfaceOrientation)rotation;
+ (UIInterfaceOrientation) oppositeOrientation:(UIInterfaceOrientation)orientation;
+ (UIImageOrientation) imageOrientationForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (UIInterfaceOrientation) interfaceOrientationForImageOrientation:(UIImageOrientation)orientation;

+ (UIImageOrientation) orientationForExif:(int)exif;
+ (CGSize) exifSizeForOrientation:(UIImageOrientation)orientation size:(CGSize)size;
+ (CGAffineTransform) exifTransformForOrientation:(UIImageOrientation)orientation size:(CGSize)size;
+ (NSString*) orientationString:(UIImageOrientation)orientaion;

+ (UIImage*) roundedImage:(UIImage*)image radius:(CGFloat)radius;													// EXIF supported
+ (UIImage*) roundedImage:(UIImage*)image size:(CGSize)size radius:(CGFloat)radius;									// EXIF supported
+ (UIImage*) roundedImage:(UIImage*)image oval:(CGSize)oval;														// EXIF supported
+ (UIImage*) roundedImage:(UIImage*)image size:(CGSize)size oval:(CGSize)oval;										// EXIF supported
+ (UIImage*) coloredImage:(UIColor*)color size:(CGSize)size stroke:(UIColor*)stroke;
+ (UIImage*) resizedImage:(UIImage*)image size:(CGSize)size;														// EXIF supported

+ (UIImage*) stretchableImage:(UIImage*)image forSize:(CGSize)size;													// EXIF supported

+ (UIImage*) imageSlice:(UIImage*)image portion:(CGPortionType)portion cap:(double)cap;								// EXIF not supported
+ (UIImage*) imageSliceOfSize:(CGSize)size image:(UIImage*)image portion:(CGPortionType)portion cap:(double)cap;	// EXIF not supported
+ (UIImage*) nineSlicedImage:(UIImage*)image size:(CGSize)size cap:(double)cap;										// EXIF not supported

+ (UIImage*) grayscaledImage:(UIImage*)image;																		// EXIF supported
+ (UIImage*) rotatedImage:(UIImage*)image orientation:(UIImageOrientation)orientation size:(CGSize)size;			// EXIF supported

+ (UIImage*) croppedImage:(UIImage*)image rect:(CGRect)rect;														// EXIF orientation and scale keeped
+ (UIImage*) croppedImage:(UIImage*)image rect:(CGRect)rect size:(CGSize)size;										// EXIF supported
+ (UIImage*) flippedImage:(UIImage*)image size:(CGSize)size vertically:(BOOL)vertically;							// EXIF supported
+ (UIImage*) reflectedImage:(UIImage*)image size:(CGSize)size;														// EXIF supported
+ (UIImage*) maskedImage:(UIImage*)image mask:(UIImage*)mask;														// EXIF not supported
+ (UIImage*) overlayedImage:(UIImage*)image overlay:(UIImage*)overlay;												// EXIF supported
+ (UIImage*) overlayedImage:(UIImage*)image overlay:(UIImage*)overlay rect:(CGRect)rect;							// EXIF supported

+ (UIImage*) normalizedImageOrientation:(UIImage*)image;															// EXIF orientation normalization
+ (UIImage*) normalizedImage:(UIImage*)image withOrientation:(UIImageOrientation)orientation;

#if HAVE_MOVIE_PLAYER
+ (UIImage*) movieThumbnail:(NSString*)path atTime:(NSTimeInterval)position;
#endif

@end
