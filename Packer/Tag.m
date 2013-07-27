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
    NSManagedObjectModel *model = context.persistentStoreCoordinator.managedObjectModel;
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"TagsWithTitle" substitutionVariables:@{@"TITLE": title}];
    [request setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:context]];
    NSParameterAssert(request.entity);
    
    NSArray *tags = [context executeFetchRequest:request error:nil];
    Tag *tag = tags.count > 0 ? tags[0] : nil;
    
    if (!tag)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:context];
        tag = [[Tag alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        tag.title = title;
    }
    
    return tag;
}

@end
