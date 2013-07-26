//
//  NSSortDescriptor+Convenience.m
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "NSSortDescriptor+Convenience.h"

@implementation NSSortDescriptor (Convenience)

+ (NSArray *)sortDescriptorsForKeys:(NSArray *)keys ascending:(BOOL)ascending
{
    NSMutableArray *descriptors = [@[] mutableCopy];
    for (NSString *key in keys)
        [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
    return descriptors;
}

@end
