//
//  OBIAutogrowTextView.h
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


@class OBIAutogrowTextView;

@protocol OBIAutogrowTextViewDelegate <NSObject>
@optional
- (void) autogrowTextViewWillResize:(OBIAutogrowTextView*)autogrowTextView;
- (void) autogrowTextViewDidResize:(OBIAutogrowTextView*)autogrowTextView;
- (void) editingStart:(OBIAutogrowTextView*)autogrowTextView;
- (void) editingStop:(OBIAutogrowTextView*)autogrowTextView;
- (void) textDidChange:(OBIAutogrowTextView*)autogrowTextView;
@end


typedef enum {
	OBIAutogrowUpwards,
	OBIAutogrowDownwards
} OBIAutogrowingType;


@interface OBIAutogrowTextView : UITextView
{
	id<OBIAutogrowTextViewDelegate> _autogrowDelegate;
	NSInteger _maximumDisplayedLines;
	NSInteger _displayedLines;
	NSInteger _contentLines;
	OBIAutogrowingType _autogrowType;
	CGRect _resizeFromFrame;
	CGRect _resizeToFrame;
	NSTimeInterval _resizeDuration;
	NSString *_lastText;
}

@property (readwrite,assign) IBOutlet id<OBIAutogrowTextViewDelegate> autogrowDelegate;
@property (readwrite,assign) NSInteger maximumDisplayedLines;
@property (readwrite,assign) NSInteger displayedLines;
@property (readwrite,assign) NSInteger contentLines;
@property (readwrite,assign) OBIAutogrowingType autogrowType;
@property (readonly,assign) CGRect resizeFromFrame;
@property (readonly,assign) CGRect resizeToFrame;
@property (readonly,assign) NSTimeInterval resizeDuration;

- (void) cancel;
- (void) setEditing:(BOOL)editing;
- (BOOL) isEditing;

@end


@interface OBIAutogrowTextView (PrivateMethods)
@property (readwrite,assign) CGRect resizeFromFrame;
@property (readwrite,assign) CGRect resizeToFrame;
@property (readwrite,assign) NSTimeInterval resizeDuration;
- (void) initInternals;
- (void) willResize;
- (void) didResize;
@end
