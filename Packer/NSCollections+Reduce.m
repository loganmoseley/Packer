//
//  NSCollections+Reduce.m
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "NSCollections+Reduce.h"

@implementation NSArray (Reduce)

- (id)reduce:(id)initial block:(id (^)(id sum, id obj))block
{
    NSParameterAssert(block != nil);
    
    __block id result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

@end

@implementation NSSet (Reduce)

- (id)reduce:(id)initial block:(id (^)(id sum, id obj))block
{
    NSParameterAssert(block != nil);
    
    __block id result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

@end
