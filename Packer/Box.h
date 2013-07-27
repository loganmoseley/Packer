//
//  Box.h
//  Packer
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Box : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSSet *items;

+ (instancetype)boxWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface Box (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
