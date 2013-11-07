//
//  ASAnimationSegment.h
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAnimationSegment : NSObject

@property (nonatomic, readonly) CGPoint destCenter;
@property (nonatomic, readonly) BOOL playSoundAtEnd;

- (id)initWithPoint:(CGPoint)destPoint playSoundAtEnd:(BOOL)playSoundAtEnd;

@end
