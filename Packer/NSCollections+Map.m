//
//  NSCollections+Map.m
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "NSCollections+Map.h"

@implementation NSArray (Map)

- (NSArray *)map:(id (^)(id))block
{
    NSParameterAssert(block != nil);
	
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id value = block(obj);
		if (!value)
			value = [NSNull null];
		
		[result addObject:value];
	}];
	
	return result;
}

@end

@implementation NSSet (Map)

- (NSSet *)map:(id (^)(id))block
{
    NSParameterAssert(block != nil);
	
	NSMutableSet *result = [NSMutableSet setWithCapacity:self.count];
    
	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		id value = block(obj);
		if (!value)
			value = [NSNull null];
		
		[result addObject:value];
	}];
	
	return result;
}

@end

@implementation NSOrderedSet (Map)

- (NSOrderedSet *)map:(id (^)(id))block
{
    NSParameterAssert(block != nil);
	
	NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity:self.count];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id value = block(obj);
		if (!value)
			value = [NSNull null];
		
		[result addObject:value];
	}];
	
	return result;
}

@end

@implementation NSDictionary (Map)

- (NSDictionary *)map:(id (^)(id, id))block
{
    NSParameterAssert(block != nil);
	
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		id value = block(key, obj);
		if (!value)
			value = [NSNull null];
		
		[result setObject:value forKey:key];
	}];
	
	return result;
}

@end



@implementation NSMutableArray (Map)

- (NSMutableArray *)map:(id (^)(id obj))block
{
    return (NSMutableArray *)[super map:block];
}

@end

@implementation NSMutableSet (Map)

- (NSMutableSet *)map:(id (^)(id))block
{
    return (NSMutableSet *)[super map:block];
}

@end

@implementation NSMutableOrderedSet (Map)

- (NSMutableOrderedSet *)map:(id (^)(id))block
{
    return (NSMutableOrderedSet *)[super map:block];
}

@end

@implementation NSMutableDictionary (Map)

- (NSMutableDictionary *)map:(id (^)(id, id))block
{
    return (NSMutableDictionary *)[super map:block];
}

@end
