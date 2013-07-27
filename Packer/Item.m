//
//  Item.m
//  Item
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Item.h"
#import "Box.h"
#import "Tag.h"
#import "NSCollections+Map.h"

@implementation Item

@dynamic info;
@dynamic name;
@dynamic packingDate;
@dynamic picture;
@dynamic sendingDate;
@dynamic tags;
@dynamic box;

+ (instancetype)insertPlaceholderItemIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    Item *item = [[Item alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:context];
    [item setName:@"Zooey Deschanel"];
    [item setImage:[UIImage imageNamed:@"zooey and kitten.jpg"]];        
    [item addTagsByTitles:[NSSet setWithArray:@[@"cute", @"kitty", @"zooey", @"blonde"]]];
    
    return item;
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
    NSManagedObjectModel *model = self.managedObjectContext.persistentStoreCoordinator.managedObjectModel;
    
    NSSet *wantedTags = [titles map:^Tag*(NSString *title) {
        NSFetchRequest *tagRequest = [model fetchRequestFromTemplateWithName:@"TagsWithTitle" substitutionVariables:@{@"TITLE": title}];
        NSArray *tags = [self.managedObjectContext executeFetchRequest:tagRequest error:nil];
        Tag *tag = tags.count > 0 ? tags[0] : nil;
        if (!tag)
            tag = [Tag tagWithTitle:title inManagedObjectContext:self.managedObjectContext];
        return tag;
    }];
    
    [self addTags:wantedTags];
}

@end
