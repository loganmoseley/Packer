//
//  Thing.m
//  Packer
//
//  Created by Logan Moseley on 8/2/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "Thing.h"
#import "Tag.h"

@implementation Thing

@dynamic notes;
@dynamic name;
@dynamic packingDate;
@dynamic picture;
@dynamic sendingDate;
@dynamic nameFirstLetter;
@dynamic tags;

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:name forKey:@"name"];
    [self didChangeValueForKey:@"name"];
    [self updateNameFirstLetterForName:name];
}

- (void)updateNameFirstLetterForName:(NSString *)name
{
    NSString *letter = name.length > 0 ? [name substringToIndex:1] : nil;
    NSString *uppercaseLetter = [letter uppercaseString];
    [self setNameFirstLetter:uppercaseLetter];
}

@end
