//
//  UIButtonAdditions.h
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


@interface UIButton (ExtendedMethods)

- (UIImage*) normalImage;
- (void) setNormalImage:(UIImage*)image;
- (UIImage*) highlightedImage;
- (void) setHighlightedImage:(UIImage*)image;
- (UIImage*) disabledImage;
- (void) setDisabledImage:(UIImage*)image;

- (UIImage*) normalBackgroundImage;
- (void) setNormalBackgroundImage:(UIImage*)image;
- (UIImage*) highlightedBackgroundImage;
- (void) setHighlightedBackgroundImage:(UIImage*)image;
- (UIImage*) disabledBackgroundImage;
- (void) setDisabledBackgroundImage:(UIImage*)image;

- (NSString*) normalTitle;
- (void) setNormalTitle:(NSString*)title;
- (NSString*) highlightedTitle;
- (void) setHighlightedTitle:(NSString*)title;
- (NSString*) disabledTitle;
- (void) setDisabledTitle:(NSString*)title;

- (NSAttributedString*) normalAttributedTitle;
- (void) setNormalAttributedTitle:(NSAttributedString*)title;
- (NSAttributedString*) highlightedAttributedTitle;
- (void) setHighlightedAttributedTitle:(NSAttributedString*)title;
- (NSAttributedString*) disabledAttributedTitle;
- (void) setDisabledAttributedTitle:(NSAttributedString*)title;

- (UIColor*) normalTitleColor;
- (void) setNormalTitleColor:(UIColor*)color;
- (UIColor*) highlightedTitleColor;
- (void) setHighlightedTitleColor:(UIColor*)color;
- (UIColor*) disabledTitleColor;
- (void) setDisabledTitleColor:(UIColor*)color;

- (void) alignLeft:(UIEdgeInsets)insets;
- (void) alignRight:(UIEdgeInsets)insets;
- (void) alignTop:(UIEdgeInsets)insets;
- (void) alignBottom:(UIEdgeInsets)insets;
- (void) adjustTitle:(UIEdgeInsets)insets;

@end
