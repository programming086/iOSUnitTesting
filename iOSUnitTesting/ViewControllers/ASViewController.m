//
//  ASViewController.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ASViewController () {
    CGPoint _ballHomePosition;  // ball's home position
    SystemSoundID _soundID; // ID for bounce sound
}

@end

@implementation ASViewController

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    // unload sound
    AudioServicesDisposeSystemSoundID(_soundID);
    _soundID = 0;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _ballHomePosition = self.ballImageView.center;
    
    // load the sound
    NSString *soundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bounce" ofType:@"mp3"];
    NSURL *soundFileUrl = [NSURL URLWithString:soundFilePath];
    OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundFileUrl), &_soundID);
#warning status == -50
//    NSAssert(status == 0, @"unexpected status: %ld", status);
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

#pragma mark - Actions methods

- (IBAction)verticalButtonDidClicked:(id)sender {
    // Destination is bottom edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(_ballHomePosition.x, viewSize.height - ballSize.height / 2);
    [self _bounceBallTo:dest];
}

- (IBAction)horizontalButtonDidClicked:(id)sender {
    // Destination is right edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(viewSize.width - ballSize.width / 2, _ballHomePosition.y);
    [self _bounceBallTo:dest];
}

#pragma mark - private methods

- (void)_bounceBallTo:(CGPoint)dest {
    self.verticalButton.hidden = YES;
    self.horizontalButton.hidden = YES;
    
    [UIView animateWithDuration:2.0 animations:^{
        self.ballImageView.center = dest;
    } completion:^(BOOL finished) {
        AudioServicesPlaySystemSound(_soundID);
        
        [UIView animateWithDuration:2.0 animations:^{
            self.ballImageView.center = _ballHomePosition;
        } completion:^(BOOL finished) {
            self.verticalButton.hidden = NO;
            self.horizontalButton.hidden = NO;
        }];
        
    }];
    
}

@end
