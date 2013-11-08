//
//  ASViewController.m
//  iOSUnitTesting
//
//  Created by Brovko Roman on 07.11.13.
//  Copyright (c) 2013 AshberrySoft. All rights reserved.
//

#import "ASViewController.h"

@interface ASViewController () {
    CGPoint _ballHomePosition;  // ball's home position
}

@end

@implementation ASViewController

- (id)init {
    self = [super initWithNibName:@"ASViewController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        self.animationManager = [[ASAnimationManager alloc] init];
        self.animationManager.delegate = self;
    }
    return self;
}

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _ballHomePosition = self.ballImageView.center;
}

#pragma mark - Actions methods

- (IBAction)verticalButtonDidClicked:(id)sender {
    [self _animationStarted];
    [self.animationManager verticalBounce:self.ballImageView];
}

- (IBAction)horizontalButtonDidClicked:(id)sender {
    [self _animationStarted];
    [self.animationManager horizontalBounce:self.ballImageView];
}

- (IBAction)fourCornerButtonDidClicked:(id)sender {
    [self _animationStarted];
    [self.animationManager fourCornerBounce:self.ballImageView];
}

#pragma mark - private methods

- (void)_animationStarted {
    self.verticalButton.hidden = YES;
    self.horizontalButton.hidden = YES;
    self.fourCornerButton.hidden = YES;
}

#pragma mark - ASAnimationManager delegate methods

- (void)animationComplete {
    self.verticalButton.hidden = NO;
    self.horizontalButton.hidden = NO;
    self.fourCornerButton.hidden = NO;
}

@end
