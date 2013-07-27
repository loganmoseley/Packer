//
//  Item.h
//  Item
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Box;

@interface Item : NSManagedObject

@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * packingDate;
@property (nonatomic, strong) NSData * picture;
@property (nonatomic, strong) NSDate * sendingDate;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, strong) Box *box;

+ (instancetype)insertPlaceholderItemIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (UIImage *)image;
- (void)setImage:(UIImage *)image;

- (void)addTagsByTitles:(NSSet *)titles;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
