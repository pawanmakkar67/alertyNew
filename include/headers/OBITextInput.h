//
//  OBITextInput.h
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
#import "OBIAutogrowTextView.h"


@class OBITextInput;

@protocol OBITextInputDelegate <NSObject>
@optional
- (void) leftAccessoryPressed:(OBITextInput*)textInput;
- (void) rightAccessoryPressed:(OBITextInput*)textInput;
- (void) willResize:(OBITextInput*)textInput;
- (void) didResize:(OBITextInput*)textInput;
- (void) editingStart:(OBITextInput*)textInput;
- (void) editingStop:(OBITextInput*)textInput;
- (void) textInputChange:(OBITextInput*)textInput;
@end


typedef enum {
	OBISnapToBottom,
	OBISnapToTop
} OBISnapType;


@interface OBITextInput : UIView <OBIAutogrowTextViewDelegate, UITextViewDelegate>
{
	id<OBITextInputDelegate> _delegate;
	OBISnapType _snapType;
	UIImageView *_bgImage;
	UIImageView *_bordTop;
	UIImageView *_bordMiddle;
	UIImageView *_bordBottom;
	
	CGRect _originalFrame;
	NSTimeInterval _keyboardOnDuration;
	CGRect _keyboardOnRect;
	BOOL _shouldMoveToKeyboard;
	BOOL _shouldDismissByHitTest;
}

@property (readwrite,assign) IBOutlet id<OBITextInputDelegate> delegate;	// to have control over it in IB
@property (readwrite,retain) IBOutlet OBIAutogrowTextView *textView;		// to have control of underlying OBIAutogrowTextView (OBITextView) in IB
@property (readwrite,retain) IBOutlet UIButton *leftAccessory;				// to have control over it in IB
@property (readwrite,retain) IBOutlet UIButton *rightAccessory;				// to have control over it in IB
@property (readwrite,assign) OBISnapType snapType;
@property (readwrite,assign) BOOL shouldMoveToKeyboard;
@property (readwrite,assign) BOOL shouldDismissByHitTest;

- (void) cancel;
- (void) setEditing:(BOOL)editing;
- (BOOL) isEditing;

- (void) setBorder:(UIImage*)image;
- (void) setBackground:(UIImage*)image;
- (void) setLeftAccessory:(UIButton*)left;
- (void) setRightAccessory:(UIButton*)right;

@end
