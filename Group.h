//
//  Group.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Group : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSSet *contacts;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;
@end
