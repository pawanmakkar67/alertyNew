//
//  CGDrawingAdditions.h
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
#import <UIKit/UIKit.h>


// CGDrawing (ExtendedMethods)

typedef enum {
	CGPortionTopLeft,
	CGPortionTopMiddle,
	CGPortionTopRight,
	CGPortionMiddleLeft,
	CGPortionMiddleMiddle,
	CGPortionMiddleRight,
	CGPortionBottomLeft,
	CGPortionBottomMiddle,
	CGPortionBottomRight,
	
	CGPortionTop,
	CGPortionLeft,
	CGPortionBottom,
	CGPortionRight,
	CGPortionCenter,
	CGPortionMiddleHoriz,
	CGPortionMiddleVert
} CGPortionType;


bool CGPointIsValid(CGPoint point);
bool CGSizeIsValid(CGSize size);
bool CGRectIsValid(CGRect rect);

bool CGSizeIsEmpty(CGSize size);

CGRect CGRectForPoint(CGPoint point);
CGRect CGRectCenterize(CGRect rect, CGRect container);

CGRect CGBoundsForRect(CGRect rect);
CGRect CGRectForSize(CGSize size);
CGRect CGRectFromSize(CGFloat x, CGFloat y, CGSize size);
CGRect CGRectFromPoint(CGPoint point, CGSize size);
CGRect CGRectForPortion(CGPortionType portion, CGRect original, double cap);

CGPoint CGPointNormalize(CGPoint point);
CGSize CGSizeNormalize(CGSize size);
CGRect CGRectNormalize(CGRect rect);

CGFloat FitScale(CGRect imagerect, CGRect containerrect, UIViewContentMode mode);
CGRect FitRect(CGRect imagerect, CGRect containerrect, UIViewContentMode mode);

CGRect ButtonFit(NSArray *buttons, NSInteger row, NSInteger column, CGFloat buttonSpacing, CGFloat buttonHeight, NSUInteger columns, CGPoint offset, CGFloat width);
CGRect MinimumFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize, NSInteger itemBias);
CGRect EqualFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize, NSInteger itemBias);
CGRect MarginFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize, NSInteger itemBias);
CGRect ArchFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect BorderFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect SimpleLeftFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect SimpleRightFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect SimpleUpFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect SimpleDownFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect SimpleUpAndLeftFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect AlignedLeftFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect AlignedRightFit(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize);
CGRect ConstantVSpacing(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize, CGFloat vSpacing, CGFloat hSpacing);
CGRect FitToLeft(NSArray *buttons, NSInteger row, NSInteger column, CGSize viewSize, CGSize itemSize, BOOL left, BOOL up, BOOL horizontalAlign, BOOL verticalAlign);

CGRect CGRectAlignedLeft(CGRect rect, CGFloat edgePt);
CGRect CGRectAlignedRight(CGRect rect, CGFloat edgePt);
CGRect CGRectAlignedTop(CGRect rect, CGFloat edgePt);
CGRect CGRectAlignedBottom(CGRect rect, CGFloat edgePt);
CGRect CGRectAlignedLeftBottom(CGRect rect, CGFloat leftEdgePt, CGFloat bottomEdgePt);
CGRect CGRectAlignedRightBottom(CGRect rect, CGFloat rightEdgePt, CGFloat bottomEdgePt);
CGRect CGRectAlignedLeftTop(CGRect rect, CGFloat leftEdgePt, CGFloat topEdgePt);
CGRect CGRectAlignedRightTop(CGRect rect, CGFloat rightEdgePt, CGFloat topEdgePt);
CGRect CGRectOffsetTo(CGRect rect, CGFloat x, CGFloat y);
CGRect CGRectOffsetToX(CGRect rect, CGFloat x);
CGRect CGRectOffsetToY(CGRect rect, CGFloat y);
CGRect CGRectResize(CGRect rect, CGSize size);
CGRect CGRectSetCenter(CGRect rect, CGPoint centerPt);
CGPoint CGRectCenter(CGRect rect);

CGSize CGSizeTranspose(CGSize size);
CGRect CGRectTranspose(CGRect rect);

CGSize CGScaleSize(CGSize size, CGFloat scale);
CGRect CGScaleRect(CGRect rect, CGFloat scale);
CGRect CGRescaleRect(CGRect rect, CGFloat rescale);

void AddRoundedRectPath(CGContextRef context, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight);
CGPathRef RoundedRectPath(CGRect rect, CGSize oval);

void CreateARGBBitmapContext(CGImageRef image, CGContextRef *outContext, uint32_t **outBitmapData);
CGImageRef CreateMaskWithImage(CGImageRef image);
