//
//  Box.m
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Box.h"
#import "Item.h"


@implementation Box

@dynamic items;

+ (instancetype)boxWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSManagedObjectModel *model = context.persistentStoreCoordinator.managedObjectModel;
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"BoxesWithName" substitutionVariables:@{@"NAME": name}];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:context];
    [request setEntity:entity];
    NSParameterAssert(request.entity);
    
    NSArray *boxes = [context executeFetchRequest:request error:nil];
    Box *box = boxes.count > 0 ? boxes[0] : nil;
    
    if (!box)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Box" inManagedObjectContext:context];
        box = [[Box alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        box.name = name;
    }
    
    return box;
}

@end
