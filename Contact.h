//
//  Contact.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

@interface Contact : NSManagedObject

@property (nonatomic, strong) NSString* _Nullable name;
@property (nonatomic, strong) NSString* _Nonnull phone;
@property (nonatomic, strong) NSNumber* _Nullable row;
@property (nonatomic, strong) NSNumber* _Nullable status;
@property (nonatomic, strong) NSNumber* _Nonnull type;
@property (nonatomic, strong) NSSet* _Nullable groups;
@property (nonatomic, strong) NSNumber* _Nullable online;
@property (nonatomic, strong) NSNumber* _Nullable lastPosition;

@property (nonatomic, readonly) NSString* _Nullable clearedPhoneNumber;

@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group* _Nonnull)value;
- (void)removeGroupsObject:(Group* _Nonnull)value;
- (void)addGroups:(NSSet* _Nonnull)values;
- (void)removeGroups:(NSSet* _Nonnull)values;
@end
