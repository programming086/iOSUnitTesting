//
//  ASAnimationSegment.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASAnimationSegment.h"

@implementation ASAnimationSegment

- (id)initWithPoint:(CGPoint)destPoint playSoundAtEnd:(BOOL)playSoundAtEnd {
    self = [super init];
    if (self) {
        _destCenter = destPoint;
        _playSoundAtEnd = playSoundAtEnd;
    }
    return self;
}

@end
