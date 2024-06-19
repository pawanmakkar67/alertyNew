//
//  PDFView.h
//
//  Created by Balint Bence on 4/19/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFTiledLayer.h"


@class PDFView;

@protocol PDFViewDelegate <NSObject>
@optional
- (void) pdfViewDidFinishRendering:(PDFView*)pdfView;
@end


@interface PDFView : UIView
{
	NSURL *_url;
	NSString *_password;
	NSInteger _page;
	CGPDFDocumentRef _pdfRef;
	CGPDFPageRef _pageRef;
	BOOL _rendering;
	id<PDFViewDelegate> _pdfDelegate;
}

@property (readwrite,assign,getter=isRendering) BOOL rendering;
@property (readwrite,assign) IBOutlet id<PDFViewDelegate> pdfDelegate;

+ (BOOL) isPasswordProtected:(NSURL*)url;
- (void) openPDFWithURL:(NSURL*)url password:(NSString*)password;
- (void) showPage:(NSInteger)page;
- (NSInteger) page;
- (NSInteger) numberOfPages;
- (CGSize) pageSize:(NSInteger)page;
- (CGAffineTransform) pageTransform:(NSInteger)page;
- (UIImage*) pageImage:(NSInteger)page size:(CGSize)size;
- (void) drawPDFLayer:(CATiledLayer *)layer inContext:(CGContextRef)context;

@end
