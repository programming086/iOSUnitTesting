//
//  ASAnimationManager.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASAnimationManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ASAnimationManager+Internal.h"

@interface ASAnimationManager () {
    UIView *_view;          // view being animated
    CGPoint _viewHome;      // where to return view after bounce
    SystemSoundID _soundID; // ID for bounce sound
}

@end

@implementation ASAnimationManager

- (id)init {
    self = [super init];
    if (self) {
        
        _duration = 2.0;    // default animation duration
        
        // load the sound
        NSString *soundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bounce" ofType:@"mp3"];
        NSURL *soundFileUrl = [NSURL URLWithString:soundFilePath];
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundFileUrl), &_soundID);
//        NSAssert(status == 0, @"unexpected status: %ld", status);
    }
    return self;
}

- (void)dealloc {
    // unload sound
    AudioServicesDisposeSystemSoundID(_soundID);
}

- (void)bounceView:(UIView *)view to:(CGPoint)dest {
    _view = view;
    _viewHome = view.center;
    
    [UIView animateWithDuration:_duration animations:^{
        _view.center = dest;
    } completion:^(BOOL finished) {
        [self _playBounceSound];
        
        [UIView animateWithDuration:_duration animations:^{
            _view.center = _viewHome;
        } completion:^(BOOL finished) {
            [self.delegate animationComplete];
        }];
        
    }];

}

#pragma mark - private methods

- (void)_playBounceSound {
    AudioServicesPlaySystemSound(_soundID);
}

@end
