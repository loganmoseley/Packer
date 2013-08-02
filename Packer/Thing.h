//
//  Thing.h
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Thing : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * packingDate;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSDate * sendingDate;
@property (nonatomic, retain) NSString * nameFirstLetter;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Thing (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
