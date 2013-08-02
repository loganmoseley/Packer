//
//  Box.h
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Thing.h"

@class Item;

@interface Box : Thing

@property (nonatomic, retain) NSSet *items;

+ (instancetype)boxWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface Box (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
