//
//  CachedObjects.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncObjects.h"


@interface CachedData : AsyncData
@end

@interface CachedString : AsyncString
@end

@interface CachedImage : AsyncImage
@end

@interface CachedJSON : AsyncJSON
@end

@interface CachedPList : AsyncPList
@end

@interface CachedXML : AsyncXML
@end
