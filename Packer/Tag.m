//
//  Tag.m
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Tag.h"


@implementation Tag

@dynamic title;
@dynamic items;

+ (instancetype)tagWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:context];
    Tag *tag = [[Tag alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:context];
    tag.title = title;
    return tag;
}

@end
