//
//  ASAnimationManager+Internal.h
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASAnimationManager.h"

@interface ASAnimationManager ()

@property (assign, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSArray *animationSegments;
@property (assign, nonatomic) NSUInteger currentSegmentIndex;
@property (weak, nonatomic) UIView *viewBeingAnimated;

- (void)_playBounceSound;

- (void)_beginAnimations:(NSArray *)segments;
- (void)_beginCurrentAnimationSegment;
- (void)_currentAnimationSegmentEnded:(BOOL)complete;

@end
