//
//  NSCollections+Map.h
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Map)
- (NSArray *)map:(id (^)(id obj))block;
@end

@interface NSSet (Map)
- (NSSet *)map:(id (^)(id obj))block;
@end

@interface NSOrderedSet (Map)
- (NSOrderedSet *)map:(id (^)(id obj))block;
@end

@interface NSDictionary (Map)
- (NSDictionary *)map:(id (^)(id key, id obj))block;
@end


@interface NSMutableArray (Map)
- (NSMutableArray *)map:(id (^)(id obj))block;
@end

@interface NSMutableSet (Map)
- (NSMutableSet *)map:(id (^)(id obj))block;
@end

@interface NSMutableOrderedSet (Map)
- (NSMutableOrderedSet *)map:(id (^)(id obj))block;
@end

@interface NSMutableDictionary (Map)
- (NSMutableDictionary *)map:(id (^)(id key, id obj))block;
@end
