//
//  ASAnimationManager.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASAnimationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ASAnimationManager+Internal.h"
#import "ASAnimationSegment.h"

@interface ASAnimationManager () {
    
}

@end

@implementation ASAnimationManager

- (id)init {
    self = [super init];
    if (self) {
        
        _duration = 2.0;    // default animation duration
        
        // load the sound
        NSString *soundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bounce" ofType:@"mp3"];
        NSURL *soundFileUrl = [NSURL fileURLWithPath:soundFilePath];
        NSError *error = nil;
        _bouncePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileUrl error:&error];
        NSAssert(_bouncePlayer != nil, [error localizedDescription]);
        [_bouncePlayer prepareToPlay];
    }
    return self;
}

- (void)verticalBounce:(UIView *)view {
    self.viewBeingAnimated = view;
    
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:[self _lowerLeftInParent:view] playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:[self _homeInParent:view] playSoundAtEnd:NO];
    
    [self _beginAnimations:@[seg1, seg2]];
}

- (void)horizontalBounce:(UIView *)view {
    self.viewBeingAnimated = view;
    
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:[self _upperRightInParents:view] playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:[self _homeInParent:view] playSoundAtEnd:NO];
    
    [self _beginAnimations:@[seg1, seg2]];
}

- (void)fourCornerBounce:(UIView *)view {
    self.viewBeingAnimated = view;
    
    ASAnimationSegment *seg1 = [[ASAnimationSegment alloc] initWithPoint:[self _lowerLeftInParent:view] playSoundAtEnd:YES];
    ASAnimationSegment *seg2 = [[ASAnimationSegment alloc] initWithPoint:[self _lowerRightInParent:view] playSoundAtEnd:YES];
    ASAnimationSegment *seg3 = [[ASAnimationSegment alloc] initWithPoint:[self _upperRightInParents:view] playSoundAtEnd:YES];
    ASAnimationSegment *seg4 = [[ASAnimationSegment alloc] initWithPoint:[self _homeInParent:view] playSoundAtEnd:NO];
    
    [self _beginAnimations:@[seg1, seg2, seg3, seg4]];
}

#pragma mark - private methods

// LCOV_EXCL_START
- (void)_playBounceSound {
    [_bouncePlayer play];
}
// LCOV_EXCL_STOP

- (CGPoint)_homeInParent:(UIView *)view {
    CGSize viewSize = view.bounds.size;
    return CGPointMake(viewSize.width / 2, viewSize.height / 2);
}

- (CGPoint)_lowerLeftInParent:(UIView *)view {
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(viewSize.width / 2, parentSize.height - viewSize.height / 2);
}

- (CGPoint)_lowerRightInParent:(UIView *)view {
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(parentSize.width - viewSize.width / 2, parentSize.height - viewSize.height / 2);
}

- (CGPoint)_upperRightInParents:(UIView *)view {
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(parentSize.width - viewSize.width / 2, viewSize.height / 2);
}

#pragma mark - Animations methods

- (void)_beginAnimations:(NSArray *)segments {
    self.animationSegments = segments;
    self.currentSegmentIndex = 0;
    [self _beginCurrentAnimationSegment];
}

- (void)_beginCurrentAnimationSegment {
    ASAnimationSegment *currentAnimationSegment = self.animationSegments[self.currentSegmentIndex];
    
    [UIView animateWithDuration:_duration animations:^{
        self.viewBeingAnimated.center = currentAnimationSegment.destCenter;
    } completion:^(BOOL finished) {
        [self _currentAnimationSegmentEnded:finished];
    }];
}

- (void)_currentAnimationSegmentEnded:(BOOL)complete {
    ASAnimationSegment *currentAnimationSegment = self.animationSegments[self.currentSegmentIndex];
    if (complete) {
        if (currentAnimationSegment.isPlaySoundAtEnd) {
            [self _playBounceSound];
        }
        
        if (self.currentSegmentIndex + 1 < [self.animationSegments count]) {
            self.currentSegmentIndex = self.currentSegmentIndex + 1;
            [self _beginCurrentAnimationSegment];
        } else {
            [self.delegate animationComplete];
        }
    } else {
        self.viewBeingAnimated.center = [self _homeInParent:self.viewBeingAnimated];
        [self.delegate animationComplete];
    }
}

@end
