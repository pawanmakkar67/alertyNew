//
//  IndoorMap.m
//  Alerty
//
//  Created by Viking on 2017. 08. 02..
//
//

#import "IndoorMap.h"
#import "AlertyDBMgr.h"

@implementation IndoorMap

@dynamic mapId;
@dynamic url;
@dynamic left;
@dynamic top;
@dynamic right;
@dynamic bottom;
@dynamic rotation;
@dynamic floor;

- (id) initWithDictionary:(NSDictionary *)dictionary {
    NSManagedObjectContext *context = [AlertyDBMgr.sharedAlertyDBMgr managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Map" inManagedObjectContext:context];
    self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    if (self) {
        self.url = dictionary[@"file"];
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        f.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        self.mapId = [f numberFromString:dictionary[@"id"]];
        self.left = [f numberFromString:dictionary[@"left"]];
        self.top = [f numberFromString:dictionary[@"top"]];
        self.right = [f numberFromString:dictionary[@"right"]];
        self.bottom = [f numberFromString:dictionary[@"bottom"]];
        self.rotation = [f numberFromString:dictionary[@"rotation"]];
        self.floor = dictionary[@"floor"];
    }
    return self;
}

@end
