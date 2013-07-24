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
@property (nonatomic, strong) Box *box;

- (NSString *)testName;
- (UIImage *)image;

@end
