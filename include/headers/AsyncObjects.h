//
//  AsyncObjects.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RemoteObjectBase.h"


@class AsyncObject;

@interface AsyncObject : RemoteObjectBase
{
	id _object;
}

@property (readwrite,retain) id object;

@end


@interface AsyncData : AsyncObject
- (NSData*) data;
@end

@interface AsyncString : AsyncObject
- (NSString*) string;
@end

@interface AsyncImage : AsyncObject
- (UIImage*) image;
@end

@interface AsyncJSON : AsyncObject
- (id) json;
@end

@interface AsyncPList : AsyncObject
- (id) plist;
@end

@interface AsyncXML : AsyncObject
- (id) xml;
@end
