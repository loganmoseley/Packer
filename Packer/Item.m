//
//  Item.m
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Item.h"
#import "Box.h"
#import "Tag.h"
#import "NSCollections+Map.h"


@implementation Item

@dynamic value;
@dynamic box;

+ (instancetype)insertBlankItemIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    Item *item = [[Item alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:context];
    return item;
}

+ (instancetype)insertPlaceholderItemIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    Item *item = [[Item alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:context];
    [item setName:@"Zooey Deschanel"];
    [item setImage:[UIImage imageNamed:@"zooey and kitten.jpg"]];
    [item addTagsByTitles:[NSSet setWithArray:@[@"cute", @"kitty", @"zooey", @"blonde"]]];
    return item;
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.packingDate = [NSDate date];
    self.sendingDate = [NSDate date];
}

- (UIImage *)image
{
    return [UIImage imageWithData:self.picture];
}

- (void)setImage:(UIImage *)image_
{
    [self setPicture:UIImageJPEGRepresentation(image_, 0.7)];
}

- (void)addTagsByTitles:(NSSet *)titles
{
    NSSet *tags = [titles map:^Tag*(NSString *title) {
        Tag *tag = [Tag tagWithTitle:title inManagedObjectContext:self.managedObjectContext];
        return tag;
    }];
    [self addTags:tags];
}


@end
