//
//  PDFFrame.h
//
//  Created by Balint Bence on 4/19/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFView.h"


@interface PDFFrame : UIScrollView <UIScrollViewDelegate>
{
	PDFView *_pdfView;
}

@property (readwrite,retain) PDFView *pdfView;

@end
