//
//  NSCollections+Reduce.h
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Reduce)
- (id)reduce:(id)initial block:(id (^)(id sum, id obj))block;
@end

@interface NSSet (Reduce)
- (id)reduce:(id)initial block:(id (^)(id sum, id obj))block;
@end
