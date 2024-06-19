//
//  CustomWebView.h
//
//  Created by Bence Balint on 20/11/13.
//  Copyright (c) 2013 viking. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomWebView : UIWebView
{
	BOOL _loadedWithRequest;
	BOOL _loadedWithHtmlString;
	BOOL _loadedWithData;
}

@property (readonly,assign) BOOL loadedWithRequest;
@property (readonly,assign) BOOL loadedWithHtmlString;
@property (readonly,assign) BOOL loadedWithData;

@end
