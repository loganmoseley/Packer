//
//  Item.m
//  Item
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Item.h"
#import "Box.h"


@implementation Item

@dynamic info;
@dynamic name;
@dynamic packingDate;
@dynamic picture;
@dynamic sendingDate;
@dynamic box;

- (NSString *)testName
{
    return @"Zooey Deschanel";
}

- (UIImage *)image
{
    return [UIImage imageWithData:self.picture];
}

@end
