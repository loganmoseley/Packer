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

@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * packingDate;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSDate * sendingDate;
@property (nonatomic, retain) Box *box;

@end
