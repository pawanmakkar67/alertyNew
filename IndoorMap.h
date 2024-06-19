//
//  IndoorMap.h
//  Alerty
//
//  Created by Viking on 2017. 08. 02..
//
//

#import <CoreData/CoreData.h>

@interface IndoorMap : NSManagedObject

@property (nonatomic, strong) NSNumber* mapId;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* left;
@property (nonatomic, strong) NSNumber* top;
@property (nonatomic, strong) NSNumber* right;
@property (nonatomic, strong) NSNumber* bottom;
@property (nonatomic, strong) NSNumber* rotation;
@property (nonatomic, strong) NSString* floor;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
