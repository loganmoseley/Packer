//
//  NSSortDescriptor+Convenience.m
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "NSSortDescriptor+Convenience.h"
#import "NSCollections+Map.h"

@implementation NSSortDescriptor (Convenience)

+ (NSArray *)sortDescriptorsForKeys:(NSArray *)keys
{
    return [self sortDescriptorsForKeys:keys ascending:YES];
}

+ (NSArray *)sortDescriptorsForKeys:(NSArray *)keys ascending:(BOOL)ascending
{
    return [keys map:^NSSortDescriptor*(NSString *key) {
        return [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    }];
}

@end
