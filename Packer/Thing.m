//
//  Thing.m
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Thing.h"
#import "Tag.h"

static char kNameObservationContext;

@implementation Thing

@dynamic notes;
@dynamic name;
@dynamic packingDate;
@dynamic picture;
@dynamic sendingDate;
@dynamic nameFirstLetter;
@dynamic tags;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:&kNameObservationContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kNameObservationContext)
    {
        NSString *name = change[NSKeyValueChangeNewKey];
        if ([name isKindOfClass:[NSString class]]) {
            NSString *letter = name.length > 0 ? [name substringToIndex:1] : nil;
            [self setPrimitiveValue:letter forKey:@"nameFirstLetter"];
        }
    }
}

@end
