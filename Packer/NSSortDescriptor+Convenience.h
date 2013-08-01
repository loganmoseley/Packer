//
//  NSSortDescriptor+Convenience.h
//  Packer
//
//  Created by Logan Moseley on 7/26/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSortDescriptor (Convenience)
+ (NSArray *)sortDescriptorsForKeys:(NSArray *)keys; // ascending == YES
+ (NSArray *)sortDescriptorsForKeys:(NSArray *)keys ascending:(BOOL)ascending;
@end
