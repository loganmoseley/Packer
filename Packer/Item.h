//
//  Item.h
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Thing.h"

@class Box;

@interface Item : Thing

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Box *box;

+ (instancetype)insertBlankItemIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)insertPlaceholderItemIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (UIImage *)image;
- (void)setImage:(UIImage *)image;

- (void)addTagsByTitles:(NSSet *)titles;

@end
